//+------------------------------------------------------------------+
//|                                                   nut_sniper.mq4 |
//|                               Copyright 2023, RookieTraders.com. |
//|                      https://www.youtube.com/watch?v=ibL1YVCrewg |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, RookieTraders.com."
#property link      "https://www.youtube.com/watch?v=ibL1YVCrewg"
#property version   "1.00"
#property strict
extern double Lots=0.01;
extern int Slippage =5;
input string MACD_H = " -----   MACD     -----";
input ENUM_TIMEFRAMES H_1 =PERIOD_H1;
input ENUM_TIMEFRAMES M_5 =PERIOD_M5;
input ENUM_APPLIED_PRICE Apply_to=PRICE_CLOSE;
input int Fast_EMA=12;
input int Slow_EMA=26;
input int MACD_SMA=9;
input string zigzag= " -----   zigzag     -----";
input int Depth=12;
input int Deviation=5;
input int Backstep=3;
input int MagicNumber =12345;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

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
//+------------------------------------------------------------------+

bool step1_buy=false;
bool step1_sell=false;
void OnTick()
  {
///int spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   if(newbar(PERIOD_H1))
     {
      if(position()==0)
        {
         if(step1_buy==false&&step1_sell==false)
           {
            checkstep1();
           }
        }
     }
//------------

   if(step1_buy==true || step1_sell==true)
     {
      checkstep2();
     }

   if(position()>0)
     {
      checkstep3();
     }
   else
      if(step1_buy==false && step1_sell==false)
        {
         Comment("Step1 Is active\n",step1_buy,"\n",step1_sell);
        }


  }
//+------------------------------------------------------------------+
void checkstep1()
  {
   int  bars=iBars(Symbol(),H_1);
   double TREND=iMACD(Symbol(),H_1,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,1);
   double  open=iOpen(Symbol(),H_1,1);
   double  close=iClose(Symbol(),H_1,1);
   int count=0;
   double z0=0;
   double z1=0;
   for(int i=0; i< bars; i++)
     {
      z0 = iCustom(Symbol(), H_1, "ZigZag", Depth, Deviation, Backstep,0,i);
      if(z0>0)
        {
         //Comment(z0,"\n",i);
         count=i+1;
         break;
        }
     }
   for(int i=count; i<bars; i++)
     {
      z1 = iCustom(Symbol(), H_1, "ZigZag", Depth, Deviation, Backstep,0,i);
      if(z1>0)
        {
         //Comment(z0,"\n",i);
         break;
        }
     }
   if(TREND>0)
     {
      if(open<close)
        {
         if(z0<z1)
           {
            step1_buy=true;
           }
        }
     }
   if(TREND<0)
     {
      if(open>close)
        {
         if(z0>z1)
           {
            step1_sell=true;
           }
        }
     }

   Comment("Step1 Is active\n",step1_buy,"\n",step1_sell);

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void checkstep2()
  {
   int  bars=iBars(Symbol(),M_5);
   int count=0;
   double z0=0;
   double z1=0;
   double z2=0;
   for(int i=0; i< bars; i++)
     {
      z0 = iCustom(Symbol(), M_5, "ZigZag", Depth, Deviation, Backstep,0,i);
      if(z0>0)
        {
         //Comment(z0,"\n",i);
         count=i+1;
         break;
        }
     }
   for(int i=count; i<bars; i++)
     {
      z1 = iCustom(Symbol(), M_5, "ZigZag", Depth, Deviation, Backstep,0,i);
      if(z1>0)
        {
         //Comment(z0,"\n",i);
         count=i+1;
         break;
        }
     }
   for(int i=count; i<bars; i++)
     {
      z2 = iCustom(Symbol(), M_5, "ZigZag", Depth, Deviation, Backstep,0,i);
      if(z2>0)
        {
         //Comment(z0,"\n",i);
         break;
        }
     }
   if(step1_buy)
     {
      if(z0<z1&&z0>z2)
        {
         int ticket=OrderSend(Symbol(),OP_BUYSTOP,Lots,z1,Slippage,z2,0,NULL,MagicNumber,0,clrNONE);
         step1_buy=false;
        }
     }
   if(step1_sell)
     {
      if(z0>z1&&z0<z2)
        {
         int ticket=OrderSend(Symbol(),OP_SELLSTOP,Lots,z1,Slippage,z2,0,NULL,MagicNumber,0,clrNONE);
         step1_sell=false;
        }
     }
   Comment("Step 2  is active");
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void checkstep3()
  {
   int  bars=iBars(Symbol(),M_5);
   double  open=iOpen(Symbol(),M_5,1);
   double  close=iClose(Symbol(),M_5,1);
   int count=0;
   double z0=0;
   double z1=0;
   double z2=0;
   for(int i=0; i< bars; i++)
     {
      z0 = iCustom(Symbol(), M_5, "ZigZag", Depth, Deviation, Backstep,0,i);
      if(z0>0)
        {
         //Comment(z0,"\n",i);
         count=i+1;
         break;
        }
     }
   for(int i=count; i<bars; i++)
     {
      z1 = iCustom(Symbol(), M_5, "ZigZag", Depth, Deviation, Backstep,0,i);
      if(z1>0)
        {
         //Comment(z0,"\n",i);
         count=i+1;
         break;
        }
     }
   for(int i=count; i<bars; i++)
     {
      z2 = iCustom(Symbol(), M_5, "ZigZag", Depth, Deviation, Backstep,0,i);
      if(z2>0)
        {
         //Comment(z0,"\n",i);
         break;
        }
     }

   for(int i = 0; i < OrdersTotal(); i++)
     {
      bool res;
      res = OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()==OP_BUYSTOP)
              {
               if(Bid<OrderStopLoss())
                 {
                  res =OrderDelete(OrderTicket());

                 }
              }
            if(OrderType()==OP_SELLSTOP)
              {
               if(Bid>OrderStopLoss())
                 {
                  res =OrderDelete(OrderTicket());

                 }
              }
            if(OrderType()==OP_BUY)
              {
               if(z0>OrderStopLoss()&&z1>OrderStopLoss())
                 {
                  res = OrderModify(OrderTicket(),OrderOpenPrice(),z1,0,0,clrNONE);
                 }
              }
            if(OrderType()==OP_SELL)
              {
               if(z0<OrderStopLoss()&&z1<OrderStopLoss())
                 {
                  res = OrderModify(OrderTicket(),OrderOpenPrice(),z1,0,0,clrNONE);
                 }
              }

           }//-------

        }//--symbol
      Comment("Step 3  is active");

     }//+end for
  }
//+------------------------------------------------------------------+










//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool newbar(int period)
  {
   static int H1;
   static int m5;
   if(period==PERIOD_H1)
     {
      if(H1!=iBars(Symbol(),period))
        {
         H1=iBars(Symbol(),period);
         return(true);
        }
     }
   if(period==PERIOD_M5)
     {
      if(m5!=iBars(Symbol(),period))
        {
         m5=iBars(Symbol(),period);
         return(true);
        }
     }
   return(false);

  }
//--------------
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
//+------------------------------------------------------------------+
