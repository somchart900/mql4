//+------------------------------------------------------------------+
//|                                                    Rapid-Fire_Pro.mq4 |
//|                         |
//|                                          |
//+------------------------------------------------------------------+
#property copyright "Rapid-Fire_Pro 2023"
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
extern double Lots =0.10;
extern double TP= 150;
extern double SL= 150;
double Start_Lots =Lots;
extern double LotsXponent =1.5;
input double maxsl=150;
input double minsl=25;
input int MagicNumber =210523;
input int Slippage =5;
input string Parbolic = " ----- Parbolic SAR Setting -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
input double Parbolic_Step =0.02;
input double Parbolic_Maximum =0.2;
input string MovingAverage = " ----- MovingAverage Setting -----";
input ENUM_MA_METHOD MA_MATHOD=MODE_SMA;
input ENUM_APPLIED_PRICE APPLIED_PRICE=PRICE_CLOSE;
input int MA_piriod=60;
input int Allow_Spread=10;
input string starttime="07:00";
input string endtime="22:00";
input double riskmoney=1;
extern double reword=2;
extern bool  Enable_ProfitLock =true;
double Lock_After_Profit=100;
input int Lock_Profit =5;
double tickvalue=0.01;
int lastbars=0;
int distant=250;
input int limitoversar=10;
double start_reword=reword;
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
// int count=0;
   double lastprofit=0;
   if(TimeLocal()>StringToTime(starttime) && TimeLocal()<StringToTime(endtime))
     {
      int today=TimeDayOfYear(TimeCurrent());
      for(int i = 0; i < OrdersHistoryTotal(); i++)
        {
         bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
         if(OrderSymbol()==Symbol())
           {
            if(TimeDayOfYear(OrderOpenTime())==today)
              {
               if(OrderMagicNumber()==MagicNumber)
                 {
                  lastprofit=OrderProfit();
                  //count++;
                 }

              }
           }
        } //--end for
      // if(profit_day>riskmoney && count >=2)
      if(lastprofit>riskmoney)
        {
         a=false;
         Print("return false with profit in taget",lastprofit);

        }
     }
   else
     {
      a=false;
      Print("return false with timesleep");
     }
   return a;
  }
//--------------------
//-----------------------------
int position()
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
            position++;
           }//-------

        }//--symbol

     }//+end for
   return position;
  }

//--------------------------------------------------------------------------------------------------
double SAR1;
double SAR0;
double MA1;
double MA20;

//+------------------------------------------------------------------+
void Treding()
  {
   SAR1=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,1);
   SAR0=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,0);
   MA1=iMA(Symbol(),TIMEFRAME,MA_piriod,0,MA_MATHOD,APPLIED_PRICE,1);
   MA20=iMA(Symbol(),TIMEFRAME,MA_piriod,0,MA_MATHOD,APPLIED_PRICE,20);
   double  open1=iOpen(Symbol(),TIMEFRAME,1);
   int  spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   int currentbars=iBars(Symbol(),TIMEFRAME);

   if(SAR1>open1)
     {
      if(SAR0<open1)
        {
         if(lastbars!=currentbars)
           {

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
           }
         lastbars=currentbars;
        }
     }//----------------




  }//+----------end treading
//----------------------------------------------------------------------------------------------------------
void TPSL()
  {
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
                     Print("Error in OrderModify. Error code=",GetLastError());
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
                     Print("Error in OrderModify. Error code=",GetLastError());
                 }
              }
           }
        }
     }
  }
//-----------------------------------------------------------------------------------------------------------------------------
void ProfitLock()
  {
   bool res;
   double price_check;
   double price_lock;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(OrderType() == OP_BUY)
              {
               price_check=OrderOpenPrice()+Lock_After_Profit*Point;
               price_lock=OrderOpenPrice()+Lock_Profit*Point;
               if(Bid >= price_check)
                 {
                  if(OrderStopLoss() != price_lock)
                    {
                     res = OrderModify(OrderTicket(),OrderOpenPrice(),price_lock,OrderTakeProfit(),0,clrGreen);
                     if(!res)
                        Print("Error in OrderModify. Error code=",GetLastError());
                    }
                 }

              }
            if(OrderType() == OP_SELL)
              {
               price_check=OrderOpenPrice()-Lock_After_Profit*Point;
               price_lock=OrderOpenPrice()-Lock_Profit*Point;
               if(Ask <= price_check)
                 {
                  if(OrderStopLoss()!= price_lock)
                    {
                     res = OrderModify(OrderTicket(),OrderOpenPrice(),price_lock,OrderTakeProfit(),0,clrRed);
                     if(!res)
                        Print("Error in OrderModify. Error code=",GetLastError());
                    }
                 }
              }

           }
        }
     }
  }
//-----------------------------------------------------------------------------------------------------------------------------
void OnTick()
  {
   Treding();
   if(Enable_ProfitLock)
      ProfitLock();
  }
//----------------------------------------------------------------------------------------------------------
double signal(int type)
  {
   bool a=false;
   double sar=0;
   double open=0;
   double check_distant=0;
   int total=300;
   int revers=1;
   MA1=iMA(Symbol(),TIMEFRAME,MA_piriod,0,MA_MATHOD,APPLIED_PRICE,1);
   MA20=iMA(Symbol(),TIMEFRAME,MA_piriod,0,MA_MATHOD,APPLIED_PRICE,20);
   if(type==OP_SELL)
     {
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
            sar=iSAR(Symbol(),0,0.02,0.2,(i-1));
            revers=i-1;
            break;
           }
        }
      check_distant=MathRound((sar-SAR0)/Point);
      ObjectDelete("trendline");
      ObjectCreate(0,"trendline",OBJ_TREND,0,Time[20],MA20,Time[1],MA1);
      if(MA20>MA1)
        {
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
            sar=iSAR(Symbol(),0,0.02,0.2,(i-1));
            revers=i-1;
            break;
           }

        }
      check_distant=MathRound((SAR0-sar)/Point);
      ObjectDelete("trendline");
      ObjectCreate(0,"trendline",OBJ_TREND,0,Time[20],MA20,Time[1],MA1);

      if(MA20<MA1)
        {
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

//----------------------------------------------------------------------------------------------------------
void history()
  {
   Lots=Start_Lots;
   bool res;
   double profit=0;
   double volume=0;
   for(int i = 0; i < OrdersHistoryTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
        {
      if(OrderSymbol()==Symbol())
         if(OrderMagicNumber()==MagicNumber)
           {
            volume=OrderLots();
            profit=OrderProfit();
           }
        }
     } //--end for
   if(profit<0)
     {
      Lots =NormalizeDouble(volume*LotsXponent,2);
     }
  }
//----------------------------
