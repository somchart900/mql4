//+------------------------------------------------------------------+
//|                                                    My_SAR.mq4 |
//|                         |
//|                                          |
//+------------------------------------------------------------------+
#property copyright "Thewiner"
#property link      "https://www.thewiner.win"
#property version   "8.00"
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
   if(GlobalVariableCheck("high")==true)
     {
      double checkup=GlobalVariableGet("high");
      if(checkup<AccountBalance())
        {
         GlobalVariableSet("high",AccountBalance());
        }
     }
   else
     {
      GlobalVariableSet("high",AccountBalance());
     }
//--------------------
   if(GlobalVariableCheck("last")==true)
     {
      double last=GlobalVariableGet("last");
      if(last!=AccountBalance())
        {
         GlobalVariableSet("last",AccountBalance());
        }
     }
   else
     {
      GlobalVariableSet("last",AccountBalance());
     }

   tickvalue=MarketInfo(Symbol(),MODE_TICKVALUE);
   if(tickvalue==0)
     {
      Print("Cannot get ticvalue");
      ExpertRemove();
     }
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Comment("");
   GlobalVariableDel("high");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
double Lots =0.1;
double TP= 0;
double SL= 0;
input int MagicNumber =270325;
input int Slippage =5;
input string Parbolic = " ----- Parbolic SAR Setting -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
input double Parbolic_Step =0.02;
input double Parbolic_Maximum =0.2;
input string MovingAverage = " ----- MovingAverage Setting -----";
input ENUM_MA_METHOD MA_MATHOD=MODE_SMA;
input ENUM_APPLIED_PRICE APPLIED_PRICE=PRICE_CLOSE;
input int MA_piriod=60;
input int Allow_Spread=200;
input string starttime="00:01";
input string endtime="23:59";
extern double percentrisk=7;
extern double Lock_After_Profit =1000;
extern int Lock_Profit =10;
double riskmoney=0;
extern double riskreword_x=1.5;
double tickvalue=0;
int lastbars=0;
int OrderStat;
string focus ="none";
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void action(int type)
  {
   double check=GlobalVariableGet("high");
   riskmoney=NormalizeDouble(check*percentrisk/100,2);
   double lots_risk=0.01;
   if(SL!=0)
     {
      lots_risk=SL*tickvalue;
     }
   else
     {
      Print("SL=0");
      ExpertRemove();
     }
   if(SL<=8000)
     {
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
   else
     {
      Print("SL Over 8000 Point");
     }
   lastbars=Bars;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int BuyOpen;
int SellOpen;
//-----------------------------
void GetStat()
  {
   BuyOpen=0;
   SellOpen=0;

   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderMagicNumber()==MagicNumber)
              {
               if(OrderType()==OP_BUY)
                 {
                  BuyOpen++;
                 }
               if(OrderType()==OP_SELL)
                 {
                  SellOpen++;
                 }
              }// end magic
           }// end symbol
        }// end select
     }// end for

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void TPSL()
  {

   TP=SL*riskreword_x;

   double SL_SET;
   double TP_SET;
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
                  if(OrderModify(OrderTicket(),OrderOpenPrice(),SL_SET,TP_SET,0,clrMagenta))
                    {
                     Print("Success OrderModify. TPSL");
                    }
                  else
                    {
                     Print("Error in OrderModify TPSL. Error code=",GetLastError());
                    }
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
                  if(OrderModify(OrderTicket(),OrderOpenPrice(),SL_SET,TP_SET,0,clrMagenta))
                    {
                     Print("Success OrderModify. TPSL");
                    }
                  else
                    {
                     Print("Error in OrderModify TPSL. Error code=",GetLastError());
                    }

                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void ProfitLock()
  {
   double stoploss;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(OrderType() == OP_BUY)
              {
               if((OrderOpenPrice()+Lock_After_Profit*Point) < Bid)
                 {
                  if(OrderStopLoss() < OrderOpenPrice()) // เพิ่มเงื่อนไขตรวจสอบ
                    {
                     Print("OrderOpenPrice "+DoubleToStr(OrderOpenPrice())+" stoploss "+DoubleToStr(OrderStopLoss()));
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+Lock_Profit*Point,OrderTakeProfit(),0,0))
                       {
                        Print("Success OrderModify Profitlock");
                       }
                     else
                       {
                        Print("Error in OrderModify Profitlock. Error code=",GetLastError());
                       }
                    }
                 }
              }
            if(OrderType() == OP_SELL)
              {
               if(OrderStopLoss()==0)
                 {
                  stoploss=OrderOpenPrice()+Lock_After_Profit*Point;
                 }
               else
                 {
                  stoploss=OrderStopLoss();
                 }
               if(OrderOpenPrice()-Lock_After_Profit*Point > Ask)
                 {
                  if(stoploss > OrderOpenPrice()) // เพิ่มเงื่อนไขตรวจสอบ
                    {
                     Print("OrderOpenPrice" + DoubleToStr(OrderOpenPrice()) + " stoploss " + DoubleToStr(stoploss));
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-Lock_Profit*Point,OrderTakeProfit(),0,0))
                       {
                        Print("Success OrderModify Profitlock");
                       }
                     else
                       {
                        Print("Error in OrderModify Profitlock. Error code=",GetLastError());
                       }
                    }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
double GetLastProfit()
  {
   double profit=0;
   for(int i = 0; i < OrdersHistoryTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderMagicNumber()==MagicNumber)
              {
               profit=OrderProfit();
              }
           }
        }
     } //--end for
   profit = MathAbs(profit);
   return profit;

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool filter()
  {
   double money=0;
   double check=GlobalVariableGet("high");
   money=NormalizeDouble(check*percentrisk/100,2);
   money=NormalizeDouble(money/2,2);
   int count=0;
   int total=OrdersHistoryTotal();
   if(OrdersHistoryTotal()>=2)
     {
      int start=total-2;
      for(int i=start; i<total; i++)
        {
         if(TimeDayOfYear(OrderCloseTime())==TimeDayOfYear(TimeCurrent()))
           {
            if(OrderSymbol()==Symbol())
              {
               if(OrderMagicNumber()==MagicNumber)
                 {
                  if(OrderProfit()>=money)
                    {
                     count++;
                    }
                 }
              }
           }
        }
     }
   if(count==2)
     {
      return false;
     }
   else
     {
      return true;
     }

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int CountOpenOrders()
  {
   int totalOrders = 0;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(OrderType() == OP_BUY || OrderType() == OP_SELL)
              {
               totalOrders++;
              }
           }
        }
     }
   return totalOrders;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  CloseSell()
  {
   for(int i=OrdersTotal()-1; i>=0; i--) //
      //for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL)
           {
            if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE))
              {
               Print("Success OrderClos. Sell");
              }
            else
              {
               Print("Error in OrderClos. Error code=",GetLastError());
              }
           }
        }

     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void  CloseBuy()
  {

   for(int i=OrdersTotal()-1; i>=0; i--)
      //for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY)
           {
            if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE))
              {
               Print("Success OrderClos. Buy");
              }
            else
              {
               Print("Error in OrderClos. Error code=",GetLastError());
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void OnTick()
  {
   int bars=iBars(Symbol(),TIMEFRAME);
   GetStat();
   if(AccountBalance()>GlobalVariableGet("high"))
     {
      GlobalVariableSet("high",AccountBalance());
     }
   if(AccountBalance()!=GlobalVariableGet("last"))
     {
     double takeprofit=NormalizeDouble(GlobalVariableGet("last")+riskmoney,2);
      if(AccountBalance()>takeprofit)
        {
          focus="none";          
        }
      GlobalVariableSet("last",AccountBalance());
     }
   double ma1=iMA(Symbol(),TIMEFRAME,MA_piriod,0,MA_MATHOD,APPLIED_PRICE,1);
   double ma15=iMA(Symbol(),TIMEFRAME,MA_piriod,0,MA_MATHOD,APPLIED_PRICE,15);
   double sar1=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,1);
   double sar0=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,0);

   double open1=iOpen(Symbol(),TIMEFRAME,1);
   double close1=iClose(Symbol(),TIMEFRAME,1);
   double high1=iHigh(Symbol(),TIMEFRAME,1);
   double low1=iLow(Symbol(),TIMEFRAME,1);

   if(sar1<open1)
     {
      if(sar0>open1)
        {
         if(ma1>ma15)
           {
            if(lastbars!=bars)
              {
               SL=MathRound((sar0-sar1)/Point);
               Lock_After_Profit=NormalizeDouble(SL*75/100,2);
               if(focus == "focus_buy")
                 {
                  if(BuyOpen>0)
                    {
                     CloseBuy();
                    }
                  if(SellOpen>0)
                    {
                     CloseSell();
                    }
                  action(OP_BUY);

                 }
              }
           }
        }
     }

   if(sar1>open1)
     {
      if(sar0<open1)
        {
         if(ma1<ma15)
           {
            if(lastbars!=bars)
              {
               SL=MathRound((sar1-sar0)/Point);
               Lock_After_Profit=NormalizeDouble(SL*75/100,2);
               if(focus == "focus_sell")
                 {
                  if(BuyOpen>0)
                    {
                     CloseBuy();
                    }
                  if(SellOpen>0)
                    {
                     CloseSell();
                    }  
                  action(OP_SELL);
                 }
              }
           }
        }
     }
   Comment("mark = "+focus+"\n rismoney = "+DoubleToStr(riskmoney,2)+ "\n TP = "+DoubleToStr(TP,2));
   ProfitLock();
   if(CountOpenOrders()!=OrderStat)
     {
      OrderStat=CountOpenOrders();
      lastbars=bars;
      Print("Lastbars Locked On CountOpenOrders Stat changes. ");
     }

   if(low1 <= ma1)
     {
      if(close1>ma1)
        {
         if(focus != "focus_buy")
           {
            focus="focus_buy";
           }
        }
     }
   if(high1 >= ma1)
     {
      if(close1<ma1)
        {
         if(focus != "focus_sell")
           {
            focus="focus_sell";
           }
        }
     }

  }//------------------------------------------------------end ontick

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
