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
extern double Lots =0.01;
extern double TP= 70;
extern double SL= 150;
extern double LotsXponent =3;
double Start_Lots =Lots;
extern int MagicNumber =100;
extern int Slippage =10;
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M1; 
extern double Parbolic_Step =0.02;
extern double Parbolic_Maximum =0.2;
input int Allow_Spred=20;
extern int TralingStart_After_Profit =90;
extern int TralingStep =90;
bool Enable_TrailingStopSell=False;
bool Enable_TrailingStopBuy=False;
int ticket,BuyOpen,SellOpen,lastbar;
double SellOpenProfit,BuyOpenProfit,mark,spd;


//----------------------------------------------------------------------------------------------------------
void OpenBuy(){ GethistoryBuy(); 
  ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,Ask-SL*Point,Ask+TP*Point,"Parbolic",MagicNumber,0,clrNONE);
  lastbar=Bars;
}
//---------------------------
void OpenSell(){ GethistorySell();

  ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Bid+SL*Point,Bid-TP*Point,"Parbolic",MagicNumber,0,clrNONE);
   lastbar=Bars;
}
//-----------------------------

//----------------------------------------------------------------------------------------------------- 

void GethistoryBuy(){ 
 bool res;
     for(int i = 0;i < OrdersHistoryTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY ){
               if(OrderProfit()<0){ Lots =OrderLots()*LotsXponent;}else{Lots=Start_Lots;}                        
           }                      
      }   
}   
 //-----------------------------
 //----------------------------------------------------------------------------------------------------- 

void GethistorySell(){ 
 bool res;
     for(int i = 0;i < OrdersHistoryTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){
               if(OrderProfit()<0){ Lots =OrderLots()*LotsXponent;}else{Lots=Start_Lots;}                        
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
              if(OrderLots()==Start_Lots){Enable_TrailingStopBuy =True;}else{ Enable_TrailingStopBuy =False;}
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
              if(OrderLots()==Start_Lots){ Enable_TrailingStopSell =True;}else{ Enable_TrailingStopSell =False;}
           }
      }   
}   
 //-----------------------------

double SAR1,SAR0;
void GetIndy(){ 
  SAR1=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,1);
  SAR0=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,0); 
     spd = Ask-Bid;
     spd=MathRound(spd/Point);
}
//--------------------------------------------------------------------------------------------------  
void Treding(){ GetIndy();  GetStatSell(); GetStatBuy();
if(SellOpen==1){SELL_TP();}
if(BuyOpen==1){BUY_TP();}
     if(SAR1 > Open[1] && SAR0 < Open[1] ){
                   if(lastbar!=Bars){
                             if(BuyOpen==0){if(spd <= Allow_Spred){OpenBuy();}}
                   }         
     }
      if(SAR1 < Open[1] && SAR0 > Open[1]){
                   if(lastbar!=Bars){
                              if(SellOpen==0){ if(spd <= Allow_Spred){ OpenSell();}}                  
                   }                   
     }


}
//----------------------------------------------------------------------------------------------------------  
void BUY_TP(){ bool res;
  for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber ){
                 if(OrderType() == OP_BUY){ double TPB =OrderOpenPrice()+TP*Point; TPB=NormalizeDouble(TPB,Digits);
                    if(OrderTakeProfit() != TPB){                                      
                          res = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-SL*Point,OrderOpenPrice()+TP*Point,0,0);                         
                     }
                 }           
          }                                    
      }       
   } 
}

//----------------------------------------------------------------------------------------------------------------------------- 

//----------------------------------------------------------------------------------------------------------  
void SELL_TP(){ bool res;
  for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber ){
                 if(OrderType() == OP_SELL){ double TPS =OrderOpenPrice()-TP*Point; TPS=NormalizeDouble(TPS,Digits);
                    if(OrderTakeProfit() != TPS){                                      
                          res = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+SL*Point,OrderOpenPrice()-TP*Point,0,0);                         
                     }
                 }           
          }                                    
      }       
   } 
}

//----------------------------------------------------------------------------------------------------------------------------- 
//----------------------------------------------------------------------------------------------------------  
void TrailingStopBuy(){ bool res;
  for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
          if(OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber){
                 if(OrderType() == OP_BUY){
                     if(Bid-OrderOpenPrice() > TralingStart_After_Profit*Point){                 
                         if(OrderStopLoss() < Bid-TralingStep*Point){ 
                          res = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TralingStep*Point,OrderTakeProfit(),0,0);
                         }
                     }
                     
                 }                          
            }       
      }
   } 
}

//-----------------------------------------------------------------------------------------------------------------------------    
//----------------------------------------------------------------------------------------------------------  
void TrailingStopSell(){ bool res;
  for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
          if(OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber){
                 if(OrderType() == OP_SELL){
                    if(OrderOpenPrice()-Ask > TralingStart_After_Profit*Point){
                        if(OrderStopLoss() > Ask+TralingStep*Point){
                           res = OrderModify(OrderTicket(),OrderOpenPrice(),Ask+TralingStep*Point,OrderTakeProfit(),0,0);                        
                        }
                    }   
                 }
                          
              }       
      }
   } 
}

void OnTick(){ 
Treding();
if(Enable_TrailingStopSell)TrailingStopSell(); 
if(Enable_TrailingStopBuy)TrailingStopBuy(); 
}
//----------------------------------------------------------------------------------------------------------

