//+------------------------------------------------------------------+
//|                                                    SAR.mq4 |
//|                         |
//|                                          |
//+------------------------------------------------------------------+
#property copyright "2023"
#property link      "https://www.facebook.com/huaylungcafe"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   ObjectsDeleteAll();
   ChartSetInteger(ChartID(),CHART_SHOW_PERIOD_SEP,0,1);
   ChartSetInteger(ChartID(),CHART_FOREGROUND,0,0);
   ChartSetInteger(ChartID(),CHART_SHOW_GRID,0,0);
   ChartSetInteger(ChartID(),CHART_SHIFT,0,1);
   ChartSetInteger(ChartID(),CHART_AUTOSCROLL,0,1);
   ChartSetInteger(ChartID(),CHART_MODE,CHART_CANDLES,1);
   ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BEAR,clrRed);
   ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BULL,clrLime);
   ChartSetInteger(ChartID(),CHART_COLOR_CHART_DOWN,clrRed);
   tickvalue=MarketInfo(Symbol(),MODE_TICKVALUE);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Comment("");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
double Lots =0.10;
double TP= 150;
double SL= 60;
input double maxsl=150;
input double minsl=25;
input int MagicNumber =110523;
input int Slippage =5;
input string Parbolic = " ----- Parbolic SAR Setting -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
input double Parbolic_Step =0.02;
input double Parbolic_Maximum =0.2;
input int Allow_Spread=10;
input string starttime="07:00";
input string endtime="22:00";
input double riskmoney=10;
extern double reword=2.5;
double start_reword=reword;
double tickvalue=0.01;
int lastbars=0;
int distant=250;
input int limitoversar=10;
//----------------------------------------------------------------------------------------------------------
void action(int type)
  {
   double lots_risk=SL*tickvalue;
   Lots=NormalizeDouble(riskmoney/lots_risk,2);
   if(type==OP_BUY)
     {
      int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,NULL,MagicNumber,0,clrGreen);
      if(ticket<0)
        {
         Print("OrderSend failed with error #",GetLastError());
        }
     }
   if(type==OP_SELL)
     {
      int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,NULL,MagicNumber,0,clrRed);
      if(ticket<0)
        {
         Print("OrderSend failed with error #",GetLastError());
        }
     }
   TPSL();
  }

//+------------------------------------------------------------------+
bool filter()
  {
   bool a=true;
   int count=0;
   double profit_day=0;
   if(TimeLocal()>StringToTime(starttime) && TimeLocal()<StringToTime(endtime))
     {
      int today=TimeDayOfYear(TimeCurrent());
      for(int i=OrdersHistoryTotal()-1; i>=0; i--)
         //for(int i = 0; i < OrdersHistoryTotal(); i++)
        {
         bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
         if(OrderSymbol()==Symbol())
           {
            if(TimeDayOfYear(OrderOpenTime())==today)
              {
               if(OrderMagicNumber()==MagicNumber)
                 {
                  profit_day+=OrderProfit();

                 }

              }
           }
        } //--end for
      if(profit_day>0)
        {
         a=false;
         Print("return false with tread  double Win");

        }
     }
   else
     {
      a=false;
      Print("return false with outside working hours");
     }
   return a;
  }
//--------------------
//-----------------------------
int position(int type)
  {
   int position=0;
   bool res;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
           {
            if(type==OP_BUY)
              {
               if(OrderType()==OP_BUY)
                 {
                  position++;
                 }
              }
            if(type==OP_SELL)
              {
               if(OrderType()==OP_SELL)
                 {
                  position++;
                 }
              }

           }//-------

        }//--symbol

     }//+end for
   return(position);
  }

//--------------------------------------------------------------------------------------------------
double  SAR1;
double  SAR0;
//+------------------------------------------------------------------+
void Treding()
  {
   SAR1=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,1);
   SAR0=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,0);
   double  open1=iOpen(Symbol(),TIMEFRAME,1);
   int  spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   int currentbars=iBars(Symbol(),TIMEFRAME);

   if(SAR1>open1)
     {
      if(SAR0<open1)
        {
         if(lastbars!=currentbars)
           {
            if(signal(OP_BUY)==true)
              {
               if(filter()==true)
                 {
                  if(spread<=Allow_Spread)
                    {
                     SL=MathRound((Ask-SAR0)/Point);

                     if(SL>=minsl&&SL<=maxsl)
                       {
                        if(position(OP_BUY)==0)
                          {
                           double Asklimit=SAR1+limitoversar*Point;
                           if(Ask < Asklimit)
                             {
                              action(OP_BUY);
                             }
                           else
                              Print("Ask Over SAR");

                          }
                        else
                           Print("already position ");
                       }
                     else
                        Print("SL Not Allow: ", SL);
                    }
                  else
                     Print("spread not allow: ",spread);
                 }
              }
           }
         lastbars=currentbars;
        }
     }//----------------
   if(SAR1<open1)
     {
      if(SAR0>open1)
        {
         if(lastbars!=currentbars)
           {
            if(signal(OP_SELL)==true)
              {
               if(filter()==true)
                 {
                  if(spread<=Allow_Spread)
                    {
                     SL=MathRound((SAR0-SAR1)/Point);
                     SL=SL+spread;
                     if(SL>=minsl&&SL<=maxsl)
                       {
                        if(position(OP_SELL)==0)
                          {
                           double bidlimit=SAR1-limitoversar*Point;
                           if(Bid>bidlimit)
                             {
                              action(OP_SELL);
                             }
                           else
                              Print("Bid over SAR");

                          }
                        else
                           Print("already position ");
                       }
                     else
                        Print("SL Not Allow: ", SL);
                    }
                  else
                     Print("spread not allow : ",spread);
                 }
              }

           }
         lastbars=currentbars;
        }
     }//----------------

  }//+----------end treading
//----------------------------------------------------------------------------------------------------------
void TPSL()
  {
   reword=start_reword;
   if(SL>100)
     {
      reword=2;
     }
   TP=SL*reword;
   double SL_SET;
   double TP_SET;
   bool res;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderMagicNumber()==MagicNumber)
              {
               if(OrderType() == OP_BUY)
                 {
                  if(SL==0)
                    {
                     SL_SET=0;
                    }
                  else
                    {
                     SL_SET=OrderOpenPrice()-SL*Point;
                    }
                  if(TP==0)
                    {
                     TP_SET=0;
                    }
                  else
                    {
                     TP_SET=OrderOpenPrice()+TP*Point;
                    }
                  res = OrderModify(OrderTicket(),OrderOpenPrice(),SL_SET,TP_SET,0,clrMagenta);
                  if(!res)
                     Print("TPSL Error in OrderModify. Error code=",GetLastError());
                 }
               if(OrderType() == OP_SELL)
                 {
                  if(SL==0)
                    {
                     SL_SET=0;
                    }
                  else
                    {
                     SL_SET=OrderOpenPrice()+SL*Point;
                    }
                  if(TP==0)
                    {
                     TP_SET=0;
                    }
                  else
                    {
                     TP_SET=OrderOpenPrice()-TP*Point;
                    }
                  res = OrderModify(OrderTicket(),OrderOpenPrice(),SL_SET,TP_SET,0,clrMagenta);
                  if(!res)
                     Print("TPSL Error in OrderModify. Error code=",GetLastError());
                 }
              }
           }
        }
     }
  }
//-----
void OnTick()
  {
   Treding();
  }
//----------------------------------------------------------------------------------------------------------
double signal(int type)
  {
   bool a=false;
   double sar=0;
   double open=0;
   double check_distant=0;
   double h0=0,h1=0;
   int total=400;
   int revers=1;
   int rever0=0;
   if(type==OP_SELL)
     {
      for(int i=revers; i<total; i++)
        {
         sar=iSAR(Symbol(),0,0.02,0.2,i);
         open=iOpen(Symbol(),0,i);
         if(sar>open)
           {
            h0=iSAR(Symbol(),0,0.02,0.2,(i-1));
            rever0=i-1;
            revers=i;
            break;
           }
        }
      for(int i=revers; i<total; i++)
        {
         sar=iSAR(Symbol(),0,0.02,0.2,i);
         open=iOpen(Symbol(),0,i);
         if(sar<open)
           {

            revers=i;
            break;
           }
        }
      for(int i=revers; i<total; i++)
        {
         sar=iSAR(Symbol(),0,0.02,0.2,i);
         open=iOpen(Symbol(),0,i);
         if(sar>open)
           {
            h1=iSAR(Symbol(),0,0.02,0.2,(i-1));
            revers=i-1;
            break;
           }
        }
      ObjectDelete("trendline");
      ObjectCreate(0,"trendline",OBJ_TREND,0,Time[revers],h1,Time[rever0],h0);
      if(h0<h1)
        {
         check_distant=MathRound((h1-h0)/Point);
         if(check_distant<distant)
           {
            a=true;
           }
         else
            Print("distant sell over limit: ",check_distant);

        }
      else
         Print("return false sell not trend");
      return a;
     }
//-------------------
   if(type==OP_BUY)
     {
      for(int i=revers; i<total; i++)
        {
         sar=iSAR(Symbol(),0,0.02,0.2,i);
         open=iOpen(Symbol(),0,i);
         if(sar<open)
           {
            h0=iSAR(Symbol(),0,0.02,0.2,(i-1));
            rever0=i-1;
            revers=i;
            break;
           }
        }
      for(int i=revers; i<total; i++)
        {
         sar=iSAR(Symbol(),0,0.02,0.2,i);
         open=iOpen(Symbol(),0,i);
         if(sar>open)
           {
            revers=i;
            break;
           }
        }
      for(int i=revers; i<total; i++)
        {
         sar=iSAR(Symbol(),0,0.02,0.2,i);
         open=iOpen(Symbol(),0,i);
         if(sar<open)
           {
            h1=iSAR(Symbol(),0,0.02,0.2,(i-1));
            revers=i-1;
            break;
           }
        }

      ObjectDelete("trendline1");
      ObjectCreate(0,"trendline1",OBJ_TREND,0,Time[revers],h1,Time[rever0],h0);
      ObjectSetInteger(0,"trendline1",OBJPROP_COLOR,clrGreen);
      if(h0>h1)
        {
         check_distant=MathRound((h0-h1)/Point);
         if(check_distant<distant)
           {
            a=true;
           }
         else
            Print("distant buy over limit: ",check_distant);

        }
      else
         Print("return false buy not trend");

      return a;
     }



   return a;
  }

//+------------------------------------------------------------------+

