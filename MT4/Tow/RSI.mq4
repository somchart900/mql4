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
extern double LotsXponent =1;
double Start_Lots =Lots;
extern int MagicNumber =20000;
extern int Slippage =10;
input int Allow_Spred=25;
extern double ProfitPerTred=20;
input int Distant=150;
input int MaxOrder=2;
input string Signal_Treding = " -----   Signal_Treding     -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
input ENUM_APPLIED_PRICE applied_price = PRICE_CLOSE; 
extern int period =14;

//-----------
input string  Trend_control = " ----- Trend_control -----";
input ENUM_TIMEFRAMES TIMEFRAME_Trend =PERIOD_H1;
input ENUM_APPLIED_PRICE applied_price_Trend = PRICE_CLOSE; 
extern int period_trend =14;

int ticket,BuyOpen,SellOpen,lastbar;
double SellOpenProfit,BuyOpenProfit,mark,spd,pos;


//----------------------------------------------------------------------------------------------------------
void OpenBuy(){ GetLotsBuy();
  ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,"",MagicNumber,0,clrNONE);
  lastbar=Bars;
}
//---------------------------
void OpenSell(){ GetLotsSell();

  ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,"",MagicNumber,0,clrNONE);
   lastbar=Bars;
}
//-----------------------------

//----------------------------------------------------------------------------------------------------- 
//-----------------------------
 void GetLotsBuy(){
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){ Lots=OrderLots()*LotsXponent;          
           }else{  Lots=Start_Lots;
           } 
      }   
}   
 //-----------------------------
//-----------------------------
 void GetLotsSell(){
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){ Lots=OrderLots()*LotsXponent;          
           }else{  Lots=Start_Lots;
           } 
      }   
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

double R50,R51,R60;
void GetIndy(){ 
R50=iRSI(NULL,TIMEFRAME,period,applied_price,1);
R51=iRSI(NULL,TIMEFRAME,period,applied_price,2);
R60=iRSI(NULL,TIMEFRAME_Trend,period_trend,applied_price_Trend,0);
     spd = Ask-Bid;
     spd=MathRound(spd/Point);
}
//--------------------------------------------------------------------------------------------------  
void Treding(){ GetIndy();  GetStatSell();GetStatBuy();
 if(R60 > 50){ CloseSell();
     if(R50 < 50 && R51 > 50 ){
                           if(BuyOpen==0){ if(spd <= Allow_Spred){ if(lastbar!=Bars){OpenBuy();}}}             
            if(BuyOpen > 0 && BuyOpen < MaxOrder){  
                if(R50 < 50 && R51 > 50 ){
                   if(Ask < mark){
                      if(spd <= Allow_Spred){ if(lastbar!=Bars){OpenBuy();}}
                   }
                }
                 if(R50 < 30 && R51 > 30 ){
                   if(Ask < mark){
                      if(spd <= Allow_Spred){ if(lastbar!=Bars){OpenBuy();}}
                   }
                }               
            }      
     } 
     //if(R50 > 70 && R51 < 70){CloseBuy();}
      Comment("Uptrend \n","ProfitBuy "+BuyOpenProfit);  
  }   
 //-----------------    
 if(R60 < 50){ CloseBuy();
     if(R50 > 50 && R51 < 50){
                           if(SellOpen==0){ if(spd <= Allow_Spred){ if(lastbar!=Bars){OpenSell();}}}             
            if(SellOpen > 0 && SellOpen < MaxOrder){  
                if(R50 > 50 && R51 < 50){
                   if(Bid > mark){
                      if(spd <= Allow_Spred){ if(lastbar!=Bars){OpenSell();}}
                   }
                }
            } 
            if(SellOpen > 0 && SellOpen < MaxOrder){  
                if(R50 > 70 && R51 < 70){
                   if(Bid > mark){
                      if(spd <= Allow_Spred){ if(lastbar!=Bars){OpenSell();}}
                   }
                }
            }                 
     } 
     //if(R50 < 30 && R51 > 30){CloseSell();}
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

