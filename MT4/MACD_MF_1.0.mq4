//+------------------------------------------------------------------+
//|                                                    .mq4 |
//|                         |
//|                                          |
//+------------------------------------------------------------------+
#property copyright ""
#property link      "https://www.facebook.com/huaylungcafe"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//ObjectsDeleteAll();
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
double TP= 155;
double SL= 150;
input int MagicNumber =20210326;
input int Slippage =5;
input string MACD = " -----   Signal_signal     -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
input ENUM_APPLIED_PRICE Apply_to=PRICE_CLOSE;
input int Fast_EMA=12;
input int Slow_EMA=26;
input int MACD_SMA=9;
input string _ = " ----- Trend control -----";
input ENUM_TIMEFRAMES TIMEFRAME_Trend =PERIOD_M15;
input int Allow_Spread=20;
input string starttime="07:00";
input string endtime="23:00";
input double riskmoney=1.0;
extern double riskreword_x=2.0;
double start_riskreword_x=riskreword_x;
extern bool  Enable_ProfitLock =true;
extern int Lock_After_Profit =100;
input int Lock_Profit =5;
int lastbars;
double tickvalue=0.01;
double S1;
double S2;
double M1;
double M2;
double TREND;
int spread;
int currentbars;
double price_sl;
//----------------------------------------------------------------------------------------------------------
void action(int type)
  {
   riskreword_x=start_riskreword_x;
   SL=SL+spread;
   if(SL>=200)
     {
      SL=200;
      riskreword_x=0.90;
     }
   if(SL>150&&SL<200)
     {
      riskreword_x=1.0;
     }
   if(SL>100&&SL<=150)
     {
      riskreword_x=1.5;
     }
   double lots_risk=SL*tickvalue;
   Lots=NormalizeDouble(riskmoney/lots_risk,2);
   Print("SL ",SL);
   Print("Lots ",Lots);
   int ticket;
   if(type==OP_BUY)
     {
      ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,NULL,MagicNumber,0,clrGreen);
      if(ticket<0)
        {
         Print("OrderSend failed with error #",GetLastError());
        }
      else
         Print("OrderSend placed successfully");
     }
   if(type==OP_SELL)
     {
      ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,NULL,MagicNumber,0,clrRed);
      if(ticket<0)
        {
         Print("OrderSend failed with error #",GetLastError());
        }
      else
         Print("OrderSend placed successfully");
     }
   TPSL();
  }


//+------------------------------------------------------------------+
bool filter()
  {
   bool a;
// int count=0;
   double profit_day=0;
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
                  //count++;
                  profit_day+=OrderProfit();
                 }

              }
           }
        } //--end for
      if(profit_day>0)
        {
         a=false;
        }
      else
        {
         a=true;

        }



     }
   else
     {
      a=false;
     }

   return a;
  }
//--------------------
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


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool signal(int type)
  {
   price_sl=Ask;
   S1=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_SIGNAL,1);
   S2=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_SIGNAL,2);
   M1=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,1);
   M2=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,2);
   TREND=iMACD(Symbol(),TIMEFRAME_Trend,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,1);
   if(type==OP_BUY)
     {
      if(TREND > 0)
        {
         if(M1>0)
           {
            if(M2<=0)
              {
               for(int i=0; i<8; i++)
                 {
                  double low=iLow(Symbol(),TIMEFRAME,i);
                  if(low<price_sl)
                    {
                     price_sl=low;
                    }
                 }

               return true;
              }
           }
         if(M1<=0)
           {
            if(M2<=S2)
              {
               if(M1>S1)
                 {
                  for(int i=0; i<8; i++)
                    {
                     double low=iLow(Symbol(),TIMEFRAME,i);
                     if(low<price_sl)
                       {
                        price_sl=low;
                       }
                    }
                  return true;
                 }
              }
           }
        }
     }
//-----------------
   if(type==OP_SELL)
     {
      if(TREND < 0)
        {
         if(M1<0)
           {
            if(M2>=0)
              {
               for(int i=0; i<8; i++)
                 {
                  double high=iHigh(Symbol(),TIMEFRAME,i);
                  if(high>price_sl)
                    {
                     price_sl=high;
                    }
                 }

               return true;
              }
           }
         if(M1>=0)
           {
            if(M2>=S2)
              {
               if(M1<S1)
                 {
                  for(int i=0; i<8; i++)
                    {
                     double high=iHigh(Symbol(),TIMEFRAME,i);
                     if(high>price_sl)
                       {
                        price_sl=high;
                       }
                    }
                  return true;
                 }
              }
           }
        }
     }
   return false;


  }
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void TPSL()
  {
   double SL_SET;
   double TP_SET;
   TP=SL*riskreword_x;
   bool res;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
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
               res = OrderModify(OrderTicket(),OrderOpenPrice(),SL_SET,TP_SET,0,0);
               if(!res)
                  Print("Error in OrderModify. Error code=",GetLastError());
               else
                  Print("Order modified successfully.");
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
               res = OrderModify(OrderTicket(),OrderOpenPrice(),SL_SET,TP_SET,0,0);
               if(!res)
                  Print("Error in OrderModify. Error code=",GetLastError());
               else
                  Print("Order modified successfully.");
              }
           }
        }
     }
  }

//-----------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
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
                     else
                        Print("Order modified successfully.");
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
                     else
                        Print("Order modified successfully.");
                    }
                 }
              }

           }
        }
     }
  }

//-----------------------------------------------------------------------------------------------------------------------------





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   currentbars=iBars(Symbol(),TIMEFRAME);
   if(lastbars!=currentbars)
     {
      if(position()==0)
        {
         if(filter()==true)
           {
            if(spread<=Allow_Spread)
              {
               if(signal(OP_BUY)==true)
                 {
                  SL=MathRound((Ask-price_sl)/Point);
                  action(OP_BUY);
                 }
               if(signal(OP_SELL)==true)
                 {
                  SL=MathRound((price_sl-Bid)/Point);
                  action(OP_SELL);
                 }
              }
           }
        }
      lastbars=currentbars;
     }

   if(Enable_ProfitLock)
      ProfitLock();

  }
//----------------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
