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
extern int MagicNumber =6052020;
extern int Slippage =10;
input int Allow_Spred=30;
extern double ProfitPerTred=30;
double Start_ProfitPerTred=ProfitPerTred;
input int Distant=300;
input int MaxOrder=3;
input string __ = " -----   Signal_Treding     -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
extern double Parbolic_Step =0.01;
extern double Parbolic_Maximum =0.06;
//-----------
input string _ = " ----- Trend control -----";
input ENUM_TIMEFRAMES TIMEFRAME_Trend =PERIOD_H4;
extern double Parbolic_Step_Trend =0.01;
extern double Parbolic_Maximum_Trend =0.06;


int ticket,BuyOpen,SellOpen,lastbar;
double SellOpenProfit,BuyOpenProfit,mark,spd;


//----------------------------------------------------------------------------------------------------------
void OpenBuy(){ 
  ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,"",MagicNumber,0,clrNONE);
  lastbar=Bars(Symbol(),TIMEFRAME);
}
//---------------------------
void OpenSell(){ 

  ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,"",MagicNumber,0,clrNONE);
   lastbar=Bars(Symbol(),TIMEFRAME);
}
//-----------------------------

 //-----------------------------
 void GetStatBuy(){ BuyOpen=0; BuyOpenProfit=0;
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){BuyOpen++;BuyOpenProfit+=OrderProfit()+OrderSwap();
             mark=OrderOpenPrice()-Distant*Point;
           } 
      }   
}   
 //-----------------------------
 //-------------------------------------------------------------------------------------------------- 

 void GetStatSell(){SellOpen=0; SellOpenProfit=0;
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){SellOpen++; SellOpenProfit+=OrderProfit()+OrderSwap();
              mark=OrderOpenPrice()+Distant*Point; 
           }
      }   
}   
 //-----------------------------

double SAR2,SAR1,SAR0;
void GetIndy(){ 
  SAR1=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,1); 
  SAR0=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,0); 
  SAR2=iSAR(Symbol(),TIMEFRAME_Trend,Parbolic_Step_Trend,Parbolic_Maximum_Trend,0); 
     spd = Ask-Bid;
     spd=MathRound(spd/Point);
}
//--------------------------------------------------------------------------------------------------  
void Treding(){ GetIndy();  GetStatSell();GetStatBuy();
 if(SAR2 < Open[1]){ CloseSell();
     if(SAR1 > Open[1] && SAR0 < Open[1] ){
                           if(BuyOpen==0){ if(spd <= Allow_Spred){ if(lastbar!=Bars(Symbol(),TIMEFRAME)){OpenBuy();}}}             
            if(BuyOpen > 0 && BuyOpen < MaxOrder){  
                if(SAR1 > Open[1] && SAR0 < Open[1] ){
                   if(Bid < mark){
                      if(spd <= Allow_Spred){ if(lastbar!=Bars(Symbol(),TIMEFRAME)){OpenBuy();}}
                   }
                }
            }      
     } 
      Comment("Uptrend \n","ProfitBuy "+BuyOpenProfit);  
  }   
 //-----------------    
 if(SAR2 > Open[1]){ CloseBuy();
     if(SAR1 < Open[1] && SAR0 > Open[1] ){
                           if(SellOpen==0){ if(spd <= Allow_Spred){ if(lastbar!=Bars(Symbol(),TIMEFRAME)){OpenSell();}}}             
            if(SellOpen > 0 && SellOpen < MaxOrder){  
                if(SAR1 < Open[1] && SAR0 > Open[1] ){
                   if(Bid > mark){
                      if(spd <= Allow_Spred){ if(lastbar!=Bars(Symbol(),TIMEFRAME)){OpenSell();}}
                   }
                }
            }      
     } 
      Comment("Downtrend \n","ProfitSell  "+SellOpenProfit);    
  }                 
 //--------------------------------    
if(SellOpenProfit > ProfitPerTred){CloseSell();}
if(BuyOpenProfit > ProfitPerTred){CloseBuy();}
}

//-------------------------------------------------------------------------------------------------- 
void  CloseSell(){ 
  bool res;
      for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           }
          
      }
}  
void  CloseBuy(){ 
  bool res;
      for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS);
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           } 
      }
}  

//----------------------------------------------------------------------------------------------------- 

void OnTick(){ 
Treding();
}
//----------------------------------------------------------------------------------------------------------

