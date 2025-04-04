//+------------------------------------------------------------------+
//|                                                       SMA_STO.mq4 |
//|                                      Copyright 2023, huaylungcafe |
//|                             https://www.facebook.com/huaylungcafe |
//+------------------------------------------------------------------+
#property copyright "2023"
#property link      "https://www.facebook.com/huaylungcafe"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
int OnInit()
  {
   if(!IsTradeAllowed())
     {
      Alert("Terminal Auto Treading disable");
      ExpertRemove();
     }
   ObjectsDeleteAll();
   ChartSetInteger(ChartID(),CHART_SHOW_PERIOD_SEP,0,1);
   ChartSetInteger(ChartID(),CHART_FOREGROUND,0,0);
   ChartSetInteger(ChartID(),CHART_SHOW_GRID,0,0);
   ChartSetInteger(ChartID(),CHART_SHOW_ASK_LINE,1);
   ChartSetInteger(ChartID(),CHART_SHOW_BID_LINE,1);
   ChartSetInteger(ChartID(),CHART_SHIFT,0,1);
   ChartSetInteger(ChartID(),CHART_AUTOSCROLL,0,1);
   ChartSetInteger(ChartID(),CHART_MODE,CHART_CANDLES,1);
   ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BEAR,clrRed);
   ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BULL,clrLime);
   ChartSetInteger(ChartID(),CHART_COLOR_CHART_DOWN,clrRed);
   ChartSetInteger(ChartID(),CHART_SCALE,3);
   ChartSetSymbolPeriod(0,Symbol(),PERIOD_M5);
   tickvalue=MarketInfo(Symbol(),MODE_TICKVALUE);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Comment("");
  }
//+------------------------------------------------------------------+
double Lots =0.10;
double TP= 150;
double SL= 150;
input int maxsl=150;
input int minsl=25;
input int MagicNumber =15523;
input int Slippage =5;
input string MovingEverage = " ----- MovingEverage Setting -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
input int MA =60;
input ENUM_MA_METHOD MA_MATHOD=MODE_SMA;
input ENUM_APPLIED_PRICE APPLIED_PRICE=PRICE_CLOSE;
input string Stochastic = " ----- Stochastic Setting -----";
input int k_period=5;
input int d_period=3;
input int slowing=3;
input int Allow_Spread=10;
input string starttime="07:00";
input string endtime="22:00";
input double riskmoney=1;
extern double riskreword_x=3;
extern bool  Enable_ProfitLock =false;
extern double Lock_After_Profit=75;
input int Lock_Profit =1;
double tickvalue=0.01;
int lastbars=0;
double price_sl=0;
//----------------------------------------------------------------------------------------------------------
void action(int type)
  {
   double lots_risk=SL*tickvalue;
   Lots=NormalizeDouble(riskmoney/lots_risk,2);
   Print("SL ",SL);
   Print("Lots ",Lots);
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
   double day=0;
//int count=0;
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
                  day+=OrderProfit();
                  //count++;
                 }

              }
           }
        } //--end for
      if(day>riskmoney/2)
        {
         Print("filter return false with profit: ",day);
         a=false;
        }
     }
   else
     {
      Print("filter return false with timesleep");
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
           }//-------end magic

        }//--end symbol

     }//--end for
   return (position);
  }
//+------------------------------------------------------------------+
bool signal(int type)
  {
   int  spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   double open1=iOpen(Symbol(),TIMEFRAME,1);
   double close1=iClose(Symbol(),TIMEFRAME,1);
   double SMA1=iMA(Symbol(),TIMEFRAME,MA,0,MA_MATHOD,APPLIED_PRICE,1);
   double SMA10=iMA(Symbol(),TIMEFRAME,MA,0,MA_MATHOD,APPLIED_PRICE,10);
   double Main1=iStochastic(Symbol(),TIMEFRAME,k_period,d_period,slowing,MODE_SMA,0,MODE_MAIN,1);
   double Main2=iStochastic(Symbol(),TIMEFRAME,k_period,d_period,slowing,MODE_SMA,0,MODE_MAIN,2);
   if(type==OP_BUY)
     {
      if(Main2<=20)
        {
         if(Main1>20)
           {
            if(close1>open1)
              {
               if(SMA1>SMA10)
                 {
                  price_sl=Ask;
                  for(int i=0; i<4; i++)
                    {
                     double low=iLow(Symbol(),TIMEFRAME,i);
                     if(low<price_sl)
                       {
                        price_sl=low;
                       }
                    }
                  if(spread<=Allow_Spread)
                    {
                     return(true);
                    }
                  else
                     Print("Spread Not Allow: ",spread);
                 }
               else
                  Print("signal return false with SMA Not SLobe");
              }
            else
               Print("signal return false with candle not trend");
           }
        }
     }
   if(type==OP_SELL)
     {
      if(Main2>=80)
        {
         if(Main1<80)
           {
            if(close1<open1)
              {
               if(SMA1<SMA10)
                 {
                  price_sl=Bid;
                  for(int i=0; i<4; i++)
                    {
                     double high=iHigh(Symbol(),TIMEFRAME,i);
                     if(high>price_sl)
                       {
                        price_sl=high;
                       }
                    }
                  if(spread<=Allow_Spread)
                    {
                     return(true);
                    }
                  else
                     Print("Spread Not Allow: ",spread);
                 }
               else
                  Print("signal return false with SMA Not SLobe");
              }
            else
               Print("signal return false with candle not trend");
           }
        }
     }
   return (false);
  }//+----------end signal
//----------------------------------------------------------------------------------------------------------
void TPSL()
  {
   double SL_SET;
   double TP_SET;
   TP=SL*riskreword_x;
   if(TP>200)
     {
      TP=200;
     }
   else
      if(TP<100)
        {
         TP=100;
        }
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
//-----------------------------------------------------------------------------------------------------------------------------
void ProfitLock()
  {
   Lock_After_Profit=SL*1.5;
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
                        Print("ProfitLock Error in OrderModify. Error code=",GetLastError());
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
                        Print("ProfitLock Error in OrderModify. Error code=",GetLastError());
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
   int currentbars=iBars(Symbol(),TIMEFRAME);
   if(lastbars!=currentbars)
     {
      if(position()==0)
        {
         if(signal(OP_BUY)==true)
           {
            SL=MathRound((Ask-price_sl)/Point);
            SL=SL+Slippage;
            if(SL<minsl)
              {
               SL=minsl;
              }
            if(SL<maxsl)
              {
               if(filter()==true)
                 {
                  action(OP_BUY);
                 }
              }
            else
               Print("SL Not Allow: ",SL);
           }
         if(signal(OP_SELL)==true)
           {
            SL=MathRound((price_sl-Bid)/Point);
            SL=SL+Allow_Spread;
            if(SL<minsl)
              {
               SL=minsl;
              }
            if(SL<maxsl)
              {
               if(filter()==true)
                 {
                  action(OP_SELL);
                 }
              }
            else
               Print("SL Not Allow: ",SL);
           }
        }//--end position checking
      lastbars=currentbars;
     }//--end lastbars checking
   if(Enable_ProfitLock)
      ProfitLock();
  }
//+------------------------------------------------------------------+
