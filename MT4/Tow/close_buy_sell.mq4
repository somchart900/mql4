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
   history();
//---
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
extern double TP= 500;
extern double SL= 0;
double SLSET= SL;
extern double LotsXponent =1.5;
double Start_Lots =Lots;
extern int MagicNumber =11062020;
extern int Slippage =10;
input string Parbolic = " ----- Parbolic SAR Setting -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
extern double Parbolic_Step =0.02;
extern double Parbolic_Maximum =0.2;
input string MovingAverage = " ----- MovingAverage Setting -----";
input ENUM_MA_METHOD MA_MATHOD=MODE_SMA;
input ENUM_APPLIED_PRICE APPLIED_PRICE=PRICE_CLOSE;
input int MA_piriod=60;
input string _ = " ----- Trend control -----";
input ENUM_TIMEFRAMES TIMEFRAME_Trend =PERIOD_H1;

input string Event_Controller = " ----- TrailingStop Setting -----";
extern bool Enable_TrailingStop =True;
extern int TralingStart_After_Profit =250;
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
double MA;
double SAR0;
double SAR1;
double AO;
int spread;
int bars;
void GetIndy()
  {
   SAR1=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,1);
   SAR0=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,0);
   MA=iMA(Symbol(),TIMEFRAME,MA_piriod,0,MA_MATHOD,APPLIED_PRICE,0);
   AO=iAO(Symbol(),TIMEFRAME_Trend,1);
   spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   bars=iBars(Symbol(),TIMEFRAME);
  }
//--------------------------------------------------------------------------------------------------
void Treding()
  {
   GetIndy();
   GetStat();
   double open1=iOpen(Symbol(),TIMEFRAME,1);
   if(AO > 0)
     {
       CloseSell();
      Comment("FOCUS BUY  \n","BUY OPEN  "+IntegerToString(BuyOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(BuyOpenProfit,2)+"\ntarget "+DoubleToStr(TP_All,2));
      if(SAR1 > open1 && SAR0 < open1 && SAR0 <= MA)
        {
         if(BuyOpen==0 && spread <= Allow_Spread && lastbar!=bars) OpenBuy();
         if(RISK!=normal)
          {
           if(BuyOpen>0 && Bid < distant_buy && spread <= Allow_Spread && lastbar!=bars) OpenBuy();
          }
        }
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
     }
   if(AO < 0)
     {
       CloseBuy();
      Comment("FOCUS SELL  \n","SELL OPEN  "+IntegerToString(SellOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(SellOpenProfit,2)+"\ntarget "+DoubleToStr(TP_All,2));
      if(SAR1 < open1 && SAR0 > open1 && SAR0 >= MA)
        {
         if(SellOpen==0 && spread <= Allow_Spread && lastbar!=bars) OpenSell();
         if(RISK!=normal)
            {
             if(SellOpen>0 && Bid > distant_sell && spread <= Allow_Spread && lastbar!=bars) OpenSell();
            }    
        }
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
     }


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
