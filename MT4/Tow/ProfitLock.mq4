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
extern double Lots =0.1;
double Lots_Start=Lots;
extern double LotsXponent =2;
extern double TP=1200;
extern int TP1 =250;
extern double SL=500;
extern bool Enable_TrailingStop =True;
extern int TralingStart_After_Profit =300;
extern int TralingStep =200;
extern bool  Enable_ProfitLock =False;
extern int Lock_After_Profit =150;
extern int Lock_Profit =10;


extern int MagicNumber =25052020;
extern int Slippage =10;
input int Allow_Spread=25;
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_H1;
bool minitp=True;
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void OpenBuy()
  {
   Lots=Lots_Start;
   double lots=0;
   double profit=0;
   for(int i = 0; i < OrdersHistoryTotal(); i++)
     {
      bool    res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
        {
         profit=OrderProfit();
         lots=OrderLots();
        }
     } //--end for
   if(profit<0)
     {
      Lots=lots*LotsXponent;
     }
   int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,Ask-SL*Point,Ask+TP*Point,"",MagicNumber,0,clrNONE);
   minitp=True;
  }
//-----------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenSell()
  {
   Lots=Lots_Start;
   double lots=0;
   double profit=0;
   for(int i = 0; i < OrdersHistoryTotal(); i++)
     {
      bool    res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
        {
         profit=OrderProfit();
         lots=OrderLots();
        }
     } //--end for
   if(profit<0)
     {
      Lots=lots*LotsXponent;
     }
   int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Bid+SL*Point,Bid-TP*Point,"",MagicNumber,0,clrNONE);
   minitp=True;
  }
//-----------------------------

//--------------------------------------------------------------------------------------------------
void  CloseSell()
  {
   bool res;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      res = OrderSelect(i,SELECT_BY_POS);
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
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      res = OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY)
        {
         res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
        }
     }
  }

//-----------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
void  CloseSellTP1()
  {
   bool res;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      res = OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL)
        {
         res = OrderClose(OrderTicket(),OrderLots()/2,OrderClosePrice(),Slippage,clrNONE);
        }

     }
   minitp=False;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  CloseBuyTP1()
  {
   bool res;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      res = OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY)
        {
         res = OrderClose(OrderTicket(),OrderLots()/2,OrderClosePrice(),Slippage,clrNONE);
        }
     }
   minitp=False;
  }

//-----------------------------------------------------------------------------------------------------

//-----------------------------
int BuyOpen;
int SellOpen;
void GetStat()
  {
   BuyOpen=0;
   SellOpen=0;
   bool res;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY)
        {
         BuyOpen++;
        }
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL)
        {
         SellOpen++;
        }
     }

  }
//-----------------------------
//----------------------------------------------------------------------------------------------------------
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


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TP_1()
  {

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(OrderType() == OP_BUY)
              {
               if(Bid-OrderOpenPrice() > TP1*Point)
                 {
                  if(minitp)
                    {
                     CloseBuyTP1();
                    }
                 }

              }
            if(OrderType() == OP_SELL)
              {
               if(OrderOpenPrice()-Ask > TP1*Point)
                 {
                  if(minitp)
                    {
                     CloseSellTP1();
                    }
                 }

              }

           }
        }
     }
  }

//-----------------------------------------------------------------------------------------------------------------------------

//--------------------------------------------
void Treding()
  {
   int vspread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   double AO=iAO(Symbol(),TIMEFRAME,1);
   GetStat();
   if(AO >0)
     {
      CloseSell();
      Comment("FOCUS_UP \n","Open  "+IntegerToString(BuyOpen));
      if(BuyOpen==0 && Open[3] > Close[3] && Open[2] > Close[2] && Close[1] >Open[1]&& Close[1] < High[3])
        {
         OpenBuy();
        }
     }
   if(AO <0)
     {
      CloseBuy();
      Comment("FOCUS_DOWN \n","Open  "+IntegerToString(SellOpen));
      if(SellOpen==0 && Open[3] < Close[3] && Open[2] < Close[2] && Close[1] <Open[1]&& Close[1] > Low[3])
        {
         OpenSell();
        }
     }
  }
iCustom
//+------------------------------------------------------------------+
//|                                                                  |
//+------iCust------------------------------------------------------------+
void OnTick()
  {
   Treding();
   TP_1();
   if(Enable_TrailingStop)
      TrailingStop();
   if(Enable_ProfitLock)
      ProfitLock();
  }
//----------------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
