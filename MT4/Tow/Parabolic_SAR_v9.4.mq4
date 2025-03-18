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
 bool res;
            maxhistoryTotalprofit=0;
            currenthistoryTotalprofit=0;                  
     for(int i = 0;i < OrdersHistoryTotal();i++){ 
           res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);   
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){                                               
                        maxhistoryTotalprofit=OrderComment();
                        currenthistoryTotalprofit+=OrderProfit()+OrderSwap()+OrderCommission();
                        
           }                 
      } //--end for      
 
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
extern double LotsXponent =2;
double Start_Lots =Lots;
extern double TP =70;
extern double TP_Point =300;
double TP_USD;
extern int MagicNumber =17052020;
extern int Slippage =10;
input int Allow_Spred=30;
input int Distant=200;
input int MaxOrder=5;
input string ParbolicSAR = " -----   TREND_Treding     -----";
input ENUM_TIMEFRAMES indyframe =PERIOD_H4;
extern double Parbolic_Step =0.01;
extern double Parbolic_Maximum =0.06;
input string ChartBars = " -----   Bars_Candle_Treding     -----";
input ENUM_TIMEFRAMES candleframe =PERIOD_M30;
extern bool Show=True;
int ticket;
int lastbarTP=1;
int SellOpen;
int BuyOpen;
double SellOpenProfit;
double BuyOpenProfit;
double markb;
double marks;
double maxhistoryTotalprofit=0;
double currenthistoryTotalprofit=0;
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void OpenBuy(){ 
     Lots=Start_Lots;   
     bool res;
     double lastorderprofit=0;
     double lastopenlots=0; 
            maxhistoryTotalprofit=0;
            currenthistoryTotalprofit=0;            
     for(int i = 0;i < OrdersHistoryTotal();i++){ 
           res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);   
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){                       
                        lastopenlots=OrderLots();
                        maxhistoryTotalprofit=OrderComment();
                        currenthistoryTotalprofit+=OrderProfit()+OrderSwap()+OrderCommission();
                        lastorderprofit=OrderProfit(); 
           }                 
      } //--end for  
                if(lastorderprofit<0){ 
                          Lots =lastopenlots*LotsXponent;
                          ticket=OrderSend(Symbol(),OP_BUY,Lots,Bid,Slippage,0,Ask+TP_Point*Point,DoubleToStr(maxhistoryTotalprofit,2),MagicNumber,0,clrNONE);
                 
                 }  
               
                if(lastorderprofit >= 0){  
                          if(maxhistoryTotalprofit>currenthistoryTotalprofit){ Lots =lastopenlots;
                                 ticket=OrderSend(Symbol(),OP_BUY,Lots,Bid,Slippage,0,Ask+TP_Point*Point,DoubleToStr(maxhistoryTotalprofit,2),MagicNumber,0,clrNONE);    
                          }else{  Lots=Start_Lots;
                                 ticket=OrderSend(Symbol(),OP_BUY,Lots,Bid,Slippage,0,Ask+TP_Point*Point,DoubleToStr(currenthistoryTotalprofit,2),MagicNumber,0,clrNONE); 
                          }  
               }   
                        
}   
 //-----------------------------
 //----------------------------------------------------------------------------------------------------- 

void OpenSell(){ 
     Lots=Start_Lots;   
     bool res;
     double lastorderprofit=0;
     double lastopenlots=0;
            maxhistoryTotalprofit=0;
            currenthistoryTotalprofit=0;                  
     for(int i = 0;i < OrdersHistoryTotal();i++){ 
           res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);   
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){                       
                        lastopenlots=OrderLots();
                        maxhistoryTotalprofit=OrderComment();
                        currenthistoryTotalprofit+=OrderProfit()+OrderSwap()+OrderCommission();
                        lastorderprofit=OrderProfit(); 
           }                 
      } //--end for 
                if(lastorderprofit<0){ 
                          Lots =lastopenlots*LotsXponent;
                          ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,Bid-TP_Point*Point,DoubleToStr(maxhistoryTotalprofit,2),MagicNumber,0,clrNONE);
                 
                 }  
               
                if(lastorderprofit >= 0){  
                          if(maxhistoryTotalprofit>currenthistoryTotalprofit){ Lots =lastopenlots;
                                 ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,Bid-TP_Point*Point,DoubleToStr(maxhistoryTotalprofit,2),MagicNumber,0,clrNONE);    
                          }else{  Lots=Start_Lots;
                                ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,Bid-TP_Point*Point,DoubleToStr(currenthistoryTotalprofit,2),MagicNumber,0,clrNONE); 
                          }  
               }           
                                                      
}   
 //-----------------------------

 //-----------------------------
 double LOpen;
double cutorder;
double lastoderpofit;

 void GetStat(){ 
 lastoderpofit=0;
 cutorder=-1000;
 BuyOpen=0; 
 BuyOpenProfit=0;
 SellOpen=0; 
 SellOpenProfit=0;
 LOpen=0;

 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){BuyOpen++;BuyOpenProfit+=OrderProfit()+OrderSwap()+OrderCommission();
             markb=OrderOpenPrice()-Distant*Point;
             LOpen=OrderLots();
             lastoderpofit=OrderProfit();
           } 
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){SellOpen++; SellOpenProfit+=OrderProfit()+OrderSwap()+OrderCommission();
             marks=OrderOpenPrice()+Distant*Point; 
             LOpen=OrderLots();
             lastoderpofit=OrderProfit();
           }                  
      }  
     TP_USD =TP*LOpen;
     cutorder=0-lastoderpofit; 
}   
 //-----------------------------
double SAR0; 
double SAR1;
void GetIndy(){  
  SAR0=iSAR(Symbol(),indyframe,Parbolic_Step,Parbolic_Maximum,0);
  SAR1=iSAR(Symbol(),indyframe,Parbolic_Step,Parbolic_Maximum,1);  
}
//--------------------------------------------------------------------------------------------------  
 int bars;
 double open;
 double opencandle;
 double closecandle;
void Treding(){ 
int    vspread = (int)MarketInfo(Symbol(),MODE_SPREAD);
open=iOpen(Symbol(),indyframe,1);
opencandle=iOpen(Symbol(),candleframe,1);
closecandle=iClose(Symbol(),candleframe,1);
bars=iBars(Symbol(),candleframe);
GetIndy();
GetStat();


 if(SAR0 < open){ CloseAllSell();   
     if(BuyOpen==0 && vspread <= Allow_Spred){ OpenBuy();} 
    // Comment("\n Uptrend ^^ \n ","\n Profit "+DoubleToStr(BuyOpenProfit,2)+"\n \n TP_USD "+DoubleToStr(TP_USD,2)+" \n \n maxhistoryTotalprofit "+DoubleToStr(maxhistoryTotalprofit,2)+"\n \n currenthistoryTotalprofit "+DoubleToStr(currenthistoryTotalprofit,2));  
  }  
 //-----------------  
  if(SAR0 > open){ CloseAllBuy();  
    if(SellOpen==0 && vspread <= Allow_Spred){ OpenSell();}            
   // Comment("\n Downtrend \n","\n Profit  "+DoubleToStr(SellOpenProfit,2)+"\n \n TP_USD "+DoubleToStr(TP_USD,2)+" \n \n maxhistoryTotalprofit "+DoubleToStr(maxhistoryTotalprofit,2)+"\n \n currenthistoryTotalprofit "+DoubleToStr(currenthistoryTotalprofit,2));    
  } 
  //-----------------

                //+-----------------------------------check TP on new bars 
                if(lastbarTP!=bars){
                        if(SellOpen >=2 && SellOpenProfit>0){CloseAllSell();}                
                        if(BuyOpen >=2 && BuyOpenProfit>0){CloseAllBuy();}          
                        if(BuyOpen>0 && lastoderpofit>TP_USD){
                           CloseLossBuy();
                           CloseLossBuy();
                           ClosePofitBuy();
                           ClosePofitBuy();
                           
                        }
                        if(SellOpen>0 && lastoderpofit>TP_USD){
                           CloseLossSell();
                           CloseLossSell();
                           ClosePofitSell();
                           ClosePofitSell();
                        }  
                        //---------------------------------------------- 
                        GetStat();                     
                      if(SellOpen > 0 && SellOpen < MaxOrder){                     
                          if(Bid > marks && vspread <= Allow_Spred){OpenSell();}                                                                
                      }   
                                     
                     if(BuyOpen > 0 && BuyOpen < MaxOrder){  
                         if(Bid < markb && vspread <= Allow_Spred){OpenBuy();}           
                      }                                       
                            lastbarTP=bars; 
                       //---+++++++++++++++++++++++++++++++++
   
                                         
                } //--end  lastbarTP   
                                    
 //--------------------------------    
}//+end treading

//-------------------------------------------------------------------------------------------------- 
void  CloseAllSell(){ 
  bool res;
       for(int i = 0;i < OrdersTotal();i++){ 
     // for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           }          
      }//-++++++++++++
                          maxhistoryTotalprofit=0;
                            currenthistoryTotalprofit=0;                  
                            for(int i = 0;i < OrdersHistoryTotal();i++){ 
                                      res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);   
                                       if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){                                               
                                                    maxhistoryTotalprofit=OrderComment();
                                                    currenthistoryTotalprofit+=OrderProfit()+OrderSwap()+OrderCommission();
                                       }                 
                             } //--end for 
                             if(currenthistoryTotalprofit>maxhistoryTotalprofit){maxhistoryTotalprofit=currenthistoryTotalprofit;} 
}  
//++++++++++++++++++++++++++
void  CloseAllBuy(){ 
  bool res;
       for(int i = 0;i < OrdersTotal();i++){ 
      //for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           } 
      }//++++++++
                           maxhistoryTotalprofit=0;
                            currenthistoryTotalprofit=0;                  
                            for(int i = 0;i < OrdersHistoryTotal();i++){ 
                                      res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);   
                                       if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){                                               
                                                    maxhistoryTotalprofit=OrderComment();
                                                    currenthistoryTotalprofit+=OrderProfit()+OrderSwap()+OrderCommission();
                                       }                 
                             } //--end for  
                             if(currenthistoryTotalprofit>maxhistoryTotalprofit){maxhistoryTotalprofit=currenthistoryTotalprofit;}     
}  

//----------------------------------------------------------------------------------------------------- 
//-------------------------------------------------------------------------------------------------- 
void  ClosePofitSell(){ 
  bool res;
       for(int i = 0;i < OrdersTotal();i++){ 
      //for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){
                  if(OrderProfit()>0){
                      res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
                   }  
           }
          
      }//-++++++++++++++++
                            maxhistoryTotalprofit=0;
                            currenthistoryTotalprofit=0;                  
                            for(int i = 0;i < OrdersHistoryTotal();i++){ 
                                      res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);   
                                       if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){                                               
                                                    maxhistoryTotalprofit=OrderComment();
                                                    currenthistoryTotalprofit+=OrderProfit()+OrderSwap()+OrderCommission();
                                       }                 
                             } //--end for  
                             if(currenthistoryTotalprofit>maxhistoryTotalprofit){maxhistoryTotalprofit=currenthistoryTotalprofit;}
}  
//++++++++++++++++
void  ClosePofitBuy(){ 
  bool res;
       for(int i = 0;i < OrdersTotal();i++){ 
     // for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){
                  if(OrderProfit()>0){
                      res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
                   } 
           } 
      }//+++++++++++++++++++++
                            
                            maxhistoryTotalprofit=0;
                            currenthistoryTotalprofit=0;                  
                            for(int i = 0;i < OrdersHistoryTotal();i++){ 
                                      res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);   
                                       if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){                                               
                                                    maxhistoryTotalprofit=OrderComment();
                                                    currenthistoryTotalprofit+=OrderProfit()+OrderSwap()+OrderCommission();
                                       }                 
                             } //--end for  
                             if(currenthistoryTotalprofit>maxhistoryTotalprofit){maxhistoryTotalprofit=currenthistoryTotalprofit;} 
}  

//----------------------------------------------------------------------------------------------------- 
 //++++++++++++++++
void  CloseLossBuy(){ 
  bool res;
       for(int i = 0;i < OrdersTotal();i++){ 
     // for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){
                   if(OrderProfit()>cutorder){
                      res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
                   }  
           } 
      }//+++++++++++++++++++++

}  

//----------------------------------------------------------------------------------------------------- 
 //++++++++++++++++
void  CloseLossSell(){ 
  bool res;
       for(int i = 0;i < OrdersTotal();i++){ 
     // for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){
                   if(OrderProfit()>cutorder){
                      res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
                   }  
           } 
      }//+++++++++++++++++++++

}  


void OnTick(){ 
Treding();
if(Show){
eng();
}else{
  hide_EA_name();
}

}
//----------------------------------------------------------------------------------------------------------

void hide_EA_name()
{
ObjectCreate("0", OBJ_BUTTON, 0, 0, 0);
ObjectSet("0", OBJPROP_XDISTANCE, 120); // start--width
ObjectSet("0", OBJPROP_YDISTANCE, 0); //--height start v v
ObjectSet("0", OBJPROP_XSIZE, 120);  //--width
ObjectSet("0", OBJPROP_YSIZE, 20);   //--height
//ObjectSet("0", OBJPROP_BORDER_COLOR,clrMediumBlue);
ObjectSet("0", OBJPROP_BORDER_COLOR,clrBlack);
ObjectSet("0", OBJPROP_BGCOLOR,clrBlack);
ObjectSetText("0","",15,NULL, clrNONE);
ObjectSet("0", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
}
//+------------------
void eng(){
/*
long height = ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0);
long width = ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0);
ObjectCreate("0", OBJ_BUTTON, 0, 0, 0);
ObjectSet("0", OBJPROP_XDISTANCE, 0);
ObjectSet("0", OBJPROP_YDISTANCE, 20);
ObjectSet("0", OBJPROP_XSIZE, 200);
ObjectSet("0", OBJPROP_YSIZE, width);
//ObjectSet("0", OBJPROP_BORDER_COLOR,clrMediumBlue);
ObjectSet("0", OBJPROP_BORDER_COLOR,clrBlack);
ObjectSet("0", OBJPROP_BGCOLOR,clrBlack);
ObjectSetText("0","", 20, NULL, clrNONE);
*/

ObjectCreate("1", OBJ_LABEL, 0, 0, 0);
if(SAR0 < open){
ObjectSetText("1","คาดว่าจะขึ้น     ", 10, "Tahoma",clrGreenYellow);
}else{ 
ObjectSetText("1","คาดว่าจะลง    ", 10, "Tahoma",clrGreenYellow);
}
ObjectSet("1", OBJPROP_XDISTANCE, 1);
ObjectSet("1", OBJPROP_YDISTANCE, 20);


ObjectCreate("2", OBJ_LABEL, 0, 0, 0);
if(SAR0 < open){
ObjectSetText("2",StringFormat("ออเดอร์ที่เปิด =   %G",BuyOpen), 10, "Tahoma", clrGreenYellow);
}else{ 
ObjectSetText("2",StringFormat("ออเดอร์ที่เปิด =   %G",SellOpen), 10, "Tahoma", clrGreenYellow);
}

ObjectSet("2", OBJPROP_XDISTANCE,1);
ObjectSet("2", OBJPROP_YDISTANCE, 40);


ObjectCreate("3", OBJ_LABEL, 0, 0, 0);
if(SAR0 < open){
ObjectSetText("3",StringFormat("กำไรรวม =     %G",BuyOpenProfit), 10,"Tahoma", clrGreenYellow);
}else{ 
ObjectSetText("3",StringFormat("กำไรรวม =    %G",SellOpenProfit), 10,"Tahoma", clrGreenYellow);
}
ObjectSet("3", OBJPROP_XDISTANCE, 1);
ObjectSet("3", OBJPROP_YDISTANCE, 60);

ObjectCreate("4", OBJ_LABEL, 0, 0, 0);
ObjectSetText("4",StringFormat("กำไรไม้ล่าสุด =     %G",lastoderpofit), 10,"Tahoma", clrGreenYellow);
ObjectSet("4", OBJPROP_XDISTANCE, 1);
ObjectSet("4", OBJPROP_YDISTANCE, 80);

ObjectCreate("5", OBJ_LABEL, 0, 0, 0);
ObjectSetText("5",StringFormat("กำไรสูงสุด =     %G",maxhistoryTotalprofit), 10,"Tahoma", clrGreenYellow);
ObjectSet("5", OBJPROP_XDISTANCE, 1);
ObjectSet("5", OBJPROP_YDISTANCE, 100);

ObjectCreate("6", OBJ_LABEL, 0, 0, 0);
ObjectSetText("6",StringFormat("กำไรปัจจุบัน  =    %G",currenthistoryTotalprofit), 10,"Tahoma", clrGreenYellow);
ObjectSet("6", OBJPROP_XDISTANCE, 1);
ObjectSet("6", OBJPROP_YDISTANCE, 120);


 
}