//+------------------------------------------------------------------+
//|                                                    .mq4 |
//|                         |
//|                                          |
//+------------------------------------------------------------------+
#property copyright "."
#property link      "https://www.facebook.com/huaylungcafe"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   ObjectsDeleteAll();
   ChartSetInteger(ChartID(),CHART_SHOW_PERIOD_SEP,0,0);
   ChartSetInteger(ChartID(),CHART_FOREGROUND,0,0);
   ChartSetInteger(ChartID(),CHART_SHOW_GRID,0,0);
   ChartSetInteger(ChartID(),CHART_SHIFT,0,1);
   ChartSetInteger(ChartID(),CHART_AUTOSCROLL,0,1);
   ChartSetInteger(ChartID(),CHART_MODE,CHART_CANDLES,1);
   ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BEAR,clrRed);
   ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BULL,clrLime);
   ChartSetInteger(ChartID(),CHART_COLOR_CHART_DOWN,clrRed);
//---
   history();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
extern double Lots =0.10;
extern double TP= 700;
extern double SL= 0;
double SLSET= SL;
extern double LotsXponent =1.5;
double Start_Lots =Lots;
extern int MagicNumber =9062020;
extern int Slippage =10;
input string MACD = " -----   Signal_Treding     -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
input ENUM_APPLIED_PRICE Apply_to=PRICE_CLOSE;
input int Fast_EMA=12;
input int Slow_EMA=26;
input int MACD_SMA=9;
input string _ = " ----- Trend control -----";
input ENUM_TIMEFRAMES TIMEFRAME_Trend =PERIOD_H1;

input string Event_Controller = " ----- TrailingStop Setting -----";
extern bool Enable_TrailingStop =True;
extern int TralingStart_After_Profit =200;
extern int TralingStep =200;
input string Event__Controller = " ----- Lock_Profit Setting -----";
extern bool  Enable_ProfitLock =False;
extern int Lock_After_Profit =150;
extern int Lock_Profit =10;
input int Allow_Spread=30;
input int distant=100;
double tpall=distant/2;
int lastbar;
enum ENUM_RISK  
   { 
    hardcore, 
    midium,  
    normal
   };
input ENUM_RISK RISK=midium;
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void OpenBuy()
  {
   history();
   int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,DoubleToStr(max,2),MagicNumber,0,clrNONE);
   TPSL();
   lastbar=bars;
  }
//-----------------------------
//-----------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenSell()
  {
   history();
   int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,DoubleToStr(max,2),MagicNumber,0,clrNONE);
   TPSL();
   lastbar=bars;
  }
//-----------------------------
int BuyOpen;
int SellOpen;
double distant_buy;
double distant_sell;
double volume;
double TP_All;
double SellOpenProfit;
double BuyOpenProfit;
//-----------------------------
void GetStat()
  {
   BuyOpen=0;
   SellOpen=0;
   distant_buy=0;
   distant_sell=0;
   volume=Start_Lots;
   SellOpenProfit=0;
   BuyOpenProfit=0;
   TP_All=0;
   bool res;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY)
        {
         BuyOpen++;
         BuyOpenProfit+=OrderProfit()+OrderSwap()+OrderCommission();
         distant_buy=OrderOpenPrice()-distant*Point;
         volume=OrderLots();
        }
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL)
        {
         SellOpen++;
         SellOpenProfit+=OrderProfit()+OrderSwap()+OrderCommission();
         distant_sell=OrderOpenPrice()+distant*Point;
         volume=OrderLots();
        }
     }//+end for
     TP_All=tpall*volume;
  }
//-----------------------------
//--------------------------------------------------------------------------------------------------
void  CloseSell()
  {
   bool res;
   for(int i=OrdersTotal()-1;i>=0;i--)
   //for(int i = 0; i < OrdersTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL)
        {
         res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
        }

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  CloseBuy()
  {
   bool res;
   for(int i=OrdersTotal()-1;i>=0;i--)
   //for(int i = 0; i < OrdersTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY)
        {
         res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
        }
     }
  }

//-----------------------------------------------------------------------------------------------------
//-----------------------------
double S1;
double S2;
double M1;
double M2;
double TREND;
int spread;
int bars;
void GetIndy()
  {
   S1=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_SIGNAL,1);
   S2=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_SIGNAL,2);
   M1=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,1);
   M2=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,2);
   TREND=iMACD(Symbol(),TIMEFRAME_Trend,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,1);
   spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   bars=iBars(Symbol(),TIMEFRAME);
  }
//--------------------------------------------------------------------------------------------------
void Treding()
  {
   GetIndy();
   GetStat();
   if(TREND > 0)
     {
      CloseSell();
      Comment("FOCUS BUY SATE 1 \n","BUY OPEN  "+IntegerToString(BuyOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(BuyOpenProfit,2)+"\ntarget "+DoubleToStr(TP_All,2));
      if(M2 < 0)
        {
         Comment("FOCUS BUY SATE 2 \n","BUY OPEN  "+IntegerToString(BuyOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(BuyOpenProfit,2)+"\ntarget "+DoubleToStr(TP_All,2));
         if(M2 < S2 && M1 > S1)
           {
            Comment("FOCUS BUY SATE 3 \n","BUY OPEN  "+IntegerToString(BuyOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(BuyOpenProfit,2)+"\ntarget "+DoubleToStr(TP_All,2));
            if(BuyOpen==0 && lastbar!=bars && spread<Allow_Spread)
              {
               OpenBuy();
              }
           }
        }
        //+-------------
        if(BuyOpen>0)
          {
          if(Bid<distant_buy && M2 < S2 && M1 > S1)
            {
             if(lastbar!=bars && spread<Allow_Spread)
               {
                if(RISK!=normal) OpenBuy();
               }
            }
          }
          //+----
          if(RISK==midium)
             {
              if(BuyOpen>=2)
                 {
                  if(BuyOpenProfit>TP_All)
                    {
                     CloseBuy();
                     CloseBuy();
                     CloseBuy();
                     CloseBuy();
                    }
                  }
              }
           if(RISK==hardcore) 
              {
               Enable_ProfitLock=True;
              }
           else
              {
               Enable_ProfitLock=False;
              }
     }
//-----------------
   if(TREND < 0)
     {
      CloseBuy();
      Comment("FOCUS SELL SATE 1 \n","SELL OPEN  "+IntegerToString(SellOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(SellOpenProfit,2)+"\ntarget "+DoubleToStr(TP_All,2));
      if(M2 > 0)
        {
         Comment("FOCUS SELL SATE 2 \n","SELL OPEN  "+IntegerToString(SellOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(SellOpenProfit,2)+"\ntarget "+DoubleToStr(TP_All,2));
         if(M2 > S2 && M1 < S1)
           {
            Comment("FOCUS SELL SATE 3 \n","SELL OPEN  "+IntegerToString(SellOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(SellOpenProfit,2)+"\ntarget "+DoubleToStr(TP_All,2));
            if(SellOpen==0 && lastbar!=bars && spread<Allow_Spread)
              {
               OpenSell();
              }
           }
        }
        //+-------------
        if(SellOpen>0)
          {
          if(Bid>distant_sell && M2 > S2 && M1 < S1)
            {
             if(lastbar!=bars && spread<Allow_Spread)
               {
                if(RISK!=normal) OpenSell();
               }
            }
          }
          //+-----
          if(RISK==midium)
             {
              if(SellOpen>=2)
                 {
                  if(SellOpenProfit>TP_All)
                    {
                     CloseSell();
                     CloseSell();
                     CloseSell();
                     CloseSell();
                    }
                  }
              }
           if(RISK==hardcore) 
              {
               Enable_ProfitLock=True;
              }
           else
              {
               Enable_ProfitLock=False;
              }  
     }
//--------------------------------


  }
//----------------------------------------------------------------------------------------------------------
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
              }
           }
        }
     }
  }

//-----------------------------------------------------------------------------------------------------------------------------


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TrailingStop()
  {
   bool res;
   double stoploss;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(OrderType() == OP_BUY)
              {
               if(Bid-OrderOpenPrice() > TralingStart_After_Profit*Point)
                 {
                  if(OrderStopLoss() < Bid-TralingStep*Point)
                    {
                     res = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TralingStep*Point,OrderTakeProfit(),0,0);
                    }
                 }

              }
            if(OrderType() == OP_SELL)
              {
               if(OrderStopLoss()==0)
                 {
                  stoploss=100000;
                 }
               else
                 {
                  stoploss=OrderStopLoss();
                 }
               if(OrderOpenPrice()-Ask > TralingStart_After_Profit*Point)
                 {
                  if(stoploss > Ask+TralingStep*Point)
                    {
                     res = OrderModify(OrderTicket(),OrderOpenPrice(),Ask+TralingStep*Point,OrderTakeProfit(),0,0);
                    }
                 }
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
   double stoploss;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(OrderType() == OP_BUY)
              {
               if(Bid-OrderOpenPrice() > Lock_After_Profit*Point)
                 {
                  if(OrderStopLoss() < OrderOpenPrice()+Lock_Profit*Point)
                    {
                     res = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+Lock_Profit*Point,OrderTakeProfit(),0,0);
                    }
                 }

              }
            if(OrderType() == OP_SELL)
              {
               if(OrderStopLoss()==0)
                 {
                  stoploss=100000;
                 }
               else
                 {
                  stoploss=OrderStopLoss();
                 }
               if(OrderOpenPrice()-Ask > Lock_After_Profit*Point)
                 {
                  if(stoploss > OrderOpenPrice()-Lock_Profit*Point)
                    {
                     res = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-Lock_Profit*Point,OrderTakeProfit(),0,0);
                    }
                 }
              }

           }
        }
     }
  }

//-----------------------------------------------------------------------------------------------------------------------------
double max;
double current;
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void history()
  {
   
   Lots=Start_Lots;
   bool res;
   double profit=0;
   double lots=0;
   max=0;
   current=0;
   for(int i = 0; i < OrdersHistoryTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
        {
         lots=OrderLots();
         max=StrToDouble(OrderComment());
         current+=OrderProfit()+OrderSwap()+OrderCommission();
         profit=OrderProfit();
        }
     } //--end for
   if(profit<0)
     {
      Lots =lots*LotsXponent;
     }
   if(profit >= 0)
     {
      if(max>current)
        {
         if(RISK==hardcore) Lots =lots; 
         if(RISK==midium) Lots=Start_Lots*LotsXponent; 

        }
     }
   if(current>max)
     {
      max=current;
     }
  }
//-----------------------------



 double rf_profit=0;
void OnTick()
  {
  
   Treding();
   if(Enable_TrailingStop)
      TrailingStop();
   if(Enable_ProfitLock)
      ProfitLock();
   if(rf_profit!=AccountBalance())
     {
      history();
      rf_profit=AccountBalance();
     }
  }
//----------------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
