//+------------------------------------------------------------------+
//|                                                    EMA_STOC.mq4 |
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
//------------------
   tickvalue=MarketInfo(Symbol(),MODE_TICKVALUE);
// Comment(tickvalue);
   return(INIT_SUCCEEDED);
  }
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
// Comment("");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
double Lots =0.10;
double TP= 150;
double SL= 75;
input int maxsl=120;
input int minsl=40;
input int MagicNumber =250423;
input int Slippage =5;
input string MovingEverage = " ----- MovingEverage Setting -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
input int MAFAST =20;
input int MASLOW =40;
input ENUM_MA_METHOD MA_MATHOD=MODE_EMA;
input ENUM_APPLIED_PRICE APPLIED_PRICE=PRICE_CLOSE;
input string Stochastic = " ----- Stochastic Setting -----";
input int k_period=5;
input int d_period=3;
input int slowing=3;
input string Zigzag= " -----   Zigzag     -----";
input int Depth=5;
input int Deviation=5;
input int Backstep=3;
input int Allow_Spread=20;
input string starttime="07:05";
input string endtime="23:30";
input double riskmoney=1.0;
input double riskreword_x=3.0;
extern bool  Enable_ProfitLock =true;
input int Lock_After_Profit =75;
input int Lock_Profit =5;

double tickvalue=0.5;
double EMAFAST;
double EMASLOW;
int bartime=0;
double z_sl=0;
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void action(int type)
  {
   double lots_risk=SL*tickvalue;
   Lots=NormalizeDouble(riskmoney/lots_risk,2);
   if(type==OP_BUY)
     {
      int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,NULL,MagicNumber,0,clrGreen);
     }
   if(type==OP_SELL)
     {
      int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,NULL,MagicNumber,0,clrRed);
     }
   TPSL();
  }


//+------------------------------------------------------------------+
bool treadtime()
  {
   bool a;
   double day=0;
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
                 }

              }
           }
        } //--end for
      if(day>0)
        {
         a=false;
         // Comment("Success Perday");
        }
      else
        {
         a=true;
         // Comment("");
        }



     }
   else
     {
      a=false;
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Treding()
  {
   int  spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   double low1=iLow(Symbol(),TIMEFRAME,1);
   double high1=iHigh(Symbol(),TIMEFRAME,1);
   double open1=iOpen(Symbol(),TIMEFRAME,1);
   double close1=iClose(Symbol(),TIMEFRAME,1);
   int currentbars=iBars(Symbol(),TIMEFRAME);
   EMAFAST=iMA(Symbol(),TIMEFRAME,MAFAST,0,MA_MATHOD,APPLIED_PRICE,1);
   EMASLOW=iMA(Symbol(),TIMEFRAME,MASLOW,0,MA_MATHOD,APPLIED_PRICE,1);
   if(position()==0)
     {
      if(EMAFAST>EMASLOW)
        {
         if(stoc(OP_BUY)==true)
           {
            if(zigzag(OP_BUY,z_sl)==true)
              {

               if(treadtime()==true)
                 {
                  if(spread<=Allow_Spread)
                    {
                     if(bartime!=currentbars)
                       {
                        SL=MathRound((Ask-z_sl)/Point);
                        //SL=SL+spread;
                        if(SL<minsl)
                          {
                           SL=minsl;
                          }
                        if(SL>maxsl)
                          {
                           SL=maxsl;
                          }
                        action(OP_BUY);
                        bartime=currentbars;
                       }

                    }
                 }

              }
           }
        }
      //------------------
      if(EMAFAST<EMASLOW)
        {
         if(stoc(OP_SELL)==true)
           {
            if(zigzag(OP_SELL,z_sl)==true)
              {

               if(treadtime()==true)
                 {
                  if(spread<=Allow_Spread)
                    {
                     if(bartime!=currentbars)
                       {
                        SL=MathRound((z_sl-Bid)/Point);
                        SL=SL+spread;
                        if(SL<minsl)
                          {
                           SL=minsl;
                          }
                        if(SL>maxsl)
                          {
                           SL=maxsl;
                          }
                        action(OP_SELL);
                        bartime=currentbars;
                       }
                    }
                 }

              }
           }
        }
      //----------------
     }




  }//+----------end treading
//----------------------------------------------------------------------------------------------------------
void TPSL()
  {
   double SL_SET;
   double TP_SET;

   TP=SL*riskreword_x;
   bool res;
//for(int i = 0; i < OrdersHistoryTotal(); i++)
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
                 }
              }
           }
        }
     }
  }

//-----------------------------------------------------------------------------------------------------------------------------
bool stoc(int type)
  {
   double Main1=iStochastic(Symbol(),TIMEFRAME,k_period,d_period,slowing,MODE_SMA,0,MODE_MAIN,1);
   double Main2=iStochastic(Symbol(),TIMEFRAME,k_period,d_period,slowing,MODE_SMA,0,MODE_MAIN,2);
//  double Signal1=iStochastic(Symbol(),TIMEFRAME,k_period,d_period,slowing,MODE_SMA,0,MODE_SIGNAL,1);
// double Signal2=iStochastic(Symbol(),TIMEFRAME,k_period,d_period,slowing,MODE_SMA,0,MODE_SIGNAL,2);
   if(type==OP_BUY)
     {
      if(Main2<20)
        {
         if(Main1>=20)
           {

            return(true);

           }
        }
     }
   if(type==OP_SELL)
     {
      if(Main2>80)
        {
         if(Main1<=80)
           {

            return(true);


           }
        }
     }
   return(false);
  }


//+------------------------------------------------------------------+
bool zigzag(int type,double&price_sl)
  {
   int count=0;
   double z0=0;
   double z1=0;
   double z2=0;
   double z3=0;
   int bars=iBars(Symbol(),TIMEFRAME);
   for(int i=0; i< bars; i++)
     {
      z0 = iCustom(Symbol(), TIMEFRAME, "ZigZag", Depth, Deviation, Backstep,0,i);
      if(z0>0)
        {
         price_sl=z0;
         count=i+1;
         break;
        }
     }
   for(int i=count; i<bars; i++)
     {
      z1 = iCustom(Symbol(), TIMEFRAME, "ZigZag", Depth, Deviation, Backstep,0,i);
      if(z1>0)
        {

         count=i+1;
         break;
        }
     }
   for(int i=count; i<bars; i++)
     {
      z2 = iCustom(Symbol(), TIMEFRAME, "ZigZag", Depth, Deviation, Backstep,0,i);
      if(z2>0)
        {
         count=i+1;
         break;
        }
     }
   for(int i=count; i<bars; i++)
     {
      z3 = iCustom(Symbol(), TIMEFRAME, "ZigZag", Depth, Deviation, Backstep,0,i);
      if(z3>0)
        {
         //count=i+1;
         break;
        }
     }
   if(type==OP_BUY)
     {

      if(z1>z3)
        {
         return(true);
        }

     }
   if(type==OP_SELL)
     {

      if(z1<z3)
        {
         return(true);
        }

     }
   return(false);
  }

//+------------------------------------------------------------------+
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
                    }
                 }

              }
            if(OrderType() == OP_SELL)
              {
               price_check=OrderOpenPrice()-Lock_After_Profit*Point;
               price_lock=OrderOpenPrice()-Lock_Profit*Point;
               if(Ask <= price_check)
                 {
                  if(OrderOpenPrice()!= price_lock)
                    {
                     res = OrderModify(OrderTicket(),OrderOpenPrice(),price_lock,OrderTakeProfit(),0,clrRed);
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

//+------------------------------------------------------------------+
