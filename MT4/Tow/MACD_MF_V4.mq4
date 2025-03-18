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
//ObjectsDeleteAll();
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
extern int TP= 100;
input int TP2=50;
extern double SL= 0;
double SLSET= SL;
extern double LotsXponent =2;
double Start_Lots =Lots;
extern int MagicNumber =30062020;
extern int Slippage =10;
input string MACD = " -----   Signal_Treding     -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
input ENUM_APPLIED_PRICE Apply_to=PRICE_CLOSE;
input int Fast_EMA=12;
input int Slow_EMA=26;
input int MACD_SMA=9;
input string _ = " ----- Trend control -----";
input ENUM_TIMEFRAMES TIMEFRAME_Trend =PERIOD_H1;

input ENUM_TIMEFRAMES ATR_TP =PERIOD_H1;
input string Event_Controller = " -----  Setting -----";
input int Allow_Spread=25;
input int distant=100;
input int maxoder=10;
int lastbar;

//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void OpenBuy()
  {
   GetStat();
 if(BuyOpen==0)
  {
   history();
  }
   int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,DoubleToStr(max,2),MagicNumber,0,clrNONE);
   lastbar=bars;
   Lots=Start_Lots;
  }
//-----------------------------
//-----------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenSell()
  {
 if(SellOpen==0)
   {
   history();
   }

   int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,DoubleToStr(max,2),MagicNumber,0,clrNONE);
   lastbar=bars;
   Lots=Start_Lots;
  }
//-----------------------------
//-----------------------------
int BuyOpen;
int SellOpen;
double distant_buy;
double distant_sell;
double volume;
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

   bool res;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()==OP_BUY)
              {
               BuyOpen++;
               BuyOpenProfit+=OrderProfit()+OrderSwap()+OrderCommission();
               distant_buy=OrderOpenPrice()-distant*Point;
               volume=OrderLots();
              }
            if(OrderType()==OP_SELL)
              {
               SellOpen++;
               SellOpenProfit+=OrderProfit()+OrderSwap()+OrderCommission();
               distant_sell=OrderOpenPrice()+distant*Point;
               volume=OrderLots();
              }
           }//-------

        }//--symbol

     }//+end for
 if(BuyOpen>0 || SellOpen >0)
  {
   Lots=volume;
  }
  }
//-----------------------------
//-----------------------------
//--------------------------------------------------------------------------------------------------
void  CloseSell()
  {
   bool res;
// for(int i=OrdersTotal()-1; i>=0; i--)
   for(int i = 0; i < OrdersTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()==OP_SELL)
              {
               res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
              }
           }
        }

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  CloseBuy()
  {
   bool res;
//for(int i=OrdersTotal()-1; i>=0; i--)
   for(int i = 0; i < OrdersTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()==OP_BUY)
              {
               res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
              }
           }
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
double TREND2;
int spread;
int bars;
void GetIndy()
  {
   S1=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_SIGNAL,1);
   S2=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_SIGNAL,2);
   M1=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,1);
   M2=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,2);
   TREND=iMACD(Symbol(),TIMEFRAME_Trend,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,1);
   TREND2=iMACD(Symbol(),TIMEFRAME_Trend,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,2);
   spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   bars=iBars(Symbol(),TIMEFRAME);
  }
//--------------------------------------------------------------------------------------------------
void Treding()
  {
   GetIndy();
   double atr=iATR(Symbol(),ATR_TP,14,1);
   double atr1=NormalizeDouble(atr,Digits);
   string atr2=StringSubstr(DoubleToStr(atr,Digits), Digits-1,3);
   TP=StrToInteger(atr2);
   if(TP<distant)
     {
      TP=distant;
     }
   GetStat();

   if(TREND > 0)
     {
      CloseSell();
      Comment("FOCUS BUY SATE 1 \n","BUY OPEN  "+IntegerToString(BuyOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(BuyOpenProfit,2));
      if(BuyOpen==0)
        {
         if(M2 < 0)
           {
            Comment("FOCUS BUY SATE 2 \n","BUY OPEN  "+IntegerToString(BuyOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(BuyOpenProfit,2));
            if(M2 <= S2)
              {
               if(M1 > S1)
                 {
                  Comment("FOCUS BUY SATE 3 \n","BUY OPEN  "+IntegerToString(BuyOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(BuyOpenProfit,2));
                  if(lastbar!=bars)
                    {
                     if(spread<=Allow_Spread)
                       {
                        OpenBuy();
                        TPSL();
                       }
                    }
                 }
              }
           }
        }
      //+-------------
      if(BuyOpen>0)
        {
         if(BuyOpen < maxoder)
           {
            if(Bid<distant_buy)
              {
               if(M2 <= S2)
                 {
                  if(M1 > S1)
                    {
                     if(lastbar!=bars)
                       {
                        if(spread<=Allow_Spread)
                          {
                           OpenBuy();
                           modify();
                          }
                       }
                    }
                 }
              }
           }
        }
     }
//-----------------
   if(TREND < 0)
     {
      CloseBuy();
      Comment("FOCUS SELL SATE 1 \n","SELL OPEN  "+IntegerToString(SellOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(SellOpenProfit,2));

      if(M2 > 0)
        {
         Comment("FOCUS SELL SATE 2 \n","SELL OPEN  "+IntegerToString(SellOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(SellOpenProfit,2));
         if(M2 >= S2)
           {
            if(M1 < S1)
              {
               Comment("FOCUS SELL SATE 3 \n","SELL OPEN  "+IntegerToString(SellOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(SellOpenProfit,2));
               if(SellOpen==0)
                 {
                  if(lastbar!=bars)
                    {
                     if(spread<=Allow_Spread)
                       {
                        OpenSell();
                        TPSL();
                       }
                    }
                 }
              }
            ////
           }
        }
      //+-------------
      if(SellOpen>0)
        {
         if(SellOpen < maxoder)
           {
            if(Bid>distant_sell)
              {
               if(M2 >= S2)
                 {
                  if(M1 < S1)
                    {
                     if(lastbar!=bars)
                       {
                        if(spread<=Allow_Spread)
                          {
                           OpenSell();
                           modify();
                          }
                       }
                    }
                 }
              }
           }
         ////////////////
        }
      //+-----

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
  }

//-----------------------------------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+


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
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
           {
            lots=OrderLots();
            max=StrToDouble(OrderComment());
            current+=OrderProfit()+OrderSwap()+OrderCommission();
            profit=OrderProfit();
           }
        }
     } //--end for
   if(profit<0)
     {
      if(max>current)
        {
         Lots =lots*LotsXponent;
        }
     }
   if(profit >= 0)
     {
      if(max>current)
        {
         Lots =lots;
        }
     }
   if(current>max)
     {
      max=current;
     }
  }
//-----------------------------
//+------------------------------------------------------------------+
double sumorder,sumlots,newlots,newtpprice,newprice;
void modify()
  {
   sumorder=0;
   sumlots=0;
   newprice=0;
   newtpprice=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderMagicNumber()==MagicNumber)
              {
               sumorder+=OrderOpenPrice()*OrderLots();
               sumlots+=OrderLots();
              }
           }
        }
     }//en f or
   newprice=NormalizeDouble(sumorder/sumlots,Digits);
   for(int j=OrdersTotal()-1; j>=0; j--)
     {
      if(OrderSelect(j,SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderMagicNumber()==MagicNumber)
              {
               if(OrderType()==OP_BUY)
                 {
                  newtpprice=newprice+TP2*Point;
                  // break;
                 }
               if(OrderType()==OP_SELL)
                 {
                  newtpprice=newprice-TP2*Point;
                  //break;
                 }
              }

           }

        }
     }// end for
   for(int k=OrdersTotal()-1; k>=0; k--)
     {
      if(OrderSelect(k,SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderMagicNumber()==MagicNumber)
              {
               if(OrderType()==OP_BUY)
                 {
                  int ticket=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),newtpprice,0,clrAliceBlue);
                 }
               if(OrderType()==OP_SELL)
                 {
                  int ticket=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),newtpprice,0,clrAliceBlue);
                 }
              }
           }
        }
     }// end for

  }
//+------------------------------------------------------------------+
//-----------------------------


//+------------------------------------------------------------------+
double rf_profit=0;
void OnTick()
  {
   Treding();
   if(rf_profit!=AccountBalance())
     {
      history();
      rf_profit=AccountBalance();
     }
  }
//----------------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
