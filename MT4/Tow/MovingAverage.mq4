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
// ObjectsDeleteAll();
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
int TP= 100;
int SL= 0;
double SLSET= SL;
extern double LotsXponent =2;
double Start_Lots =Lots;
extern int MagicNumber =8072020;
extern int Slippage =5;
input string PERIODSetting = " ----- PERIOD Setting -----";
input ENUM_TIMEFRAMES PERIOD =PERIOD_H1;
input ENUM_TIMEFRAMES PERIOD_TP1 =PERIOD_H4;
input string MovingAverageSetting = " ----- MovingAverage Setting -----";
input ENUM_MA_METHOD MA_MATHOD=MODE_EMA;
input ENUM_APPLIED_PRICE APPLIED_PRICE=PRICE_CLOSE;
input int MA_FAST=14;
input int MA_SLOW=44;
input string Event_Controller = " ----- Controller Setting -----";
input int Allow_Spread=10;
input int distant=100;
extern int TP2=100;
int lastbar;
enum ENUM_RISK
  {
   hardcore,
   midium,
  };
input ENUM_RISK RISK=midium;
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void OpenBuy()
  {
   if(BuyOpen==0)
     {
      history();
     }
   int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,DoubleToStr(max,2),MagicNumber,0,clrBlue);
   lastbar=bars;
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
   int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,DoubleToStr(max,2),MagicNumber,0,clrRed);
   lastbar=bars;
  }
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
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
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
      if(RISK==hardcore)
        {
         Lots=NormalizeDouble(volume*LotsXponent,2);
        }
      if(RISK==midium)
        {
         Lots=volume;
        }
     }
  }
//-----------------------------
//--------------------------------------------------------------------------------------------------
void  CloseSell()
  {
   bool res;
    //  for(int i=OrdersTotal()-1; i>=0; i--)
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


double max;
double current;
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
         Lots =NormalizeDouble(lots*LotsXponent,2);
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
//--------------------------------------------------------------------

int bars;
//--------------------------------------------------------------------------------------------------
void Treding()
  {
   GetStat();
   double EMAFAST1=iMA(Symbol(),PERIOD,MA_FAST,0,MA_MATHOD,APPLIED_PRICE,1);
   double EMASLOW1=iMA(Symbol(),PERIOD,MA_SLOW,0,MA_MATHOD,APPLIED_PRICE,1);
   double EMAFAST2=iMA(Symbol(),PERIOD,MA_FAST,0,MA_MATHOD,APPLIED_PRICE,2);
   double EMASLOW2=iMA(Symbol(),PERIOD,MA_SLOW,0,MA_MATHOD,APPLIED_PRICE,2);
   int spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   bars=iBars(Symbol(),PERIOD);

   double atr=iATR(Symbol(),PERIOD_TP1,14,1);
   double atr1=NormalizeDouble(atr,Digits);
   string atr2=StringSubstr(DoubleToStr(atr,Digits), Digits-1,3);
   TP=StrToInteger(atr2);
   if(TP<distant)
     {
      TP=distant;
     }

//-++++++++++++++
   if(EMAFAST2 < EMASLOW2 && EMAFAST1 > EMASLOW1)
     {CloseSell();
      if(spread<=Allow_Spread)
        {
         if(BuyOpen==0)
           {
            if(lastbar!=bars)
              {
               OpenBuy();
               TPSL();
              }
           }
        }
     }
   if(EMAFAST1 > EMASLOW2)
     {
      Comment("FOCUS BUY  \n","BUY OPEN  "+IntegerToString(BuyOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(BuyOpenProfit,2));
     //CloseSell();
      if(BuyOpen==0)
        {
         if(lastbar!=bars)
           {
            if(Bid<EMAFAST1)
              {
               if(spread<=Allow_Spread)
                 {
                  OpenBuy();
                  TPSL();
                 }
              }
           }
        }
      //-------------------
      if(BuyOpen>=1)
        {
         if(lastbar!=bars)
           {
            if(Bid < distant_buy)
              {
               if(Bid<EMASLOW2)
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
//+-------------------
   if(EMAFAST2 > EMASLOW2 && EMAFAST1 < EMASLOW1)
     { CloseBuy();
      if(spread<=Allow_Spread)
        {
         if(SellOpen==0)
           {
            if(lastbar!=bars)
              {
               OpenSell();
               TPSL();
              }
           }
        }
     }

   if(EMAFAST1 < EMASLOW1)
     {
      Comment("FOCUS SELL  \n","SELL OPEN  "+IntegerToString(SellOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(SellOpenProfit,2));
      //CloseBuy();
      if(SellOpen==0)
        {
         if(lastbar!=bars)
           {
            if(Bid>EMAFAST1)
              {
               if(spread<=Allow_Spread)
                 {
                  OpenSell();
                  TPSL();
                 }
              }
           }
         //----
        }
      //-----------------
      if(SellOpen>=1)
        {
         if(lastbar!=bars)
           {
            if(Bid > distant_sell)
              {
               if(Bid > EMASLOW2)
                 {
                  if(spread<=Allow_Spread)
                    {
                     OpenSell();
                     modify();
                    }
                 }
              }
           }
         //-------------------
        }
     }



  }//+----------end treading
//----------------------------------------------------------------------------------------------------------
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
