public with sharing class SwapComponent {
    
    public class PrevNewIP{
        public SVMXC__Installed_Product__c previousIP;// = new SVMXC__Installed_Product__c();
        public SVMXC__Installed_Product__c newIP;// = new SVMXC__Installed_Product__c();
        public Product_Swap__c pswap;// = new Product_Swap__c();
        public SVMXC__Service_Order__c workorder;
    }
    public List<PrevNewIP> PrevNewIPs = new List<PrevNewIP>();
    public static void SwapNow(Product_Swap__c[] swaps){
        Map<id, Product_Swap__c> swapMap = new Map<id,Product_Swap__c>();
        for(Product_Swap__c i: swaps){
            swapMap.put(i.id, i);
        } 
        Integer TriggerCount=-1; TriggerCount=0;    
        List<Product_Swap__c> updateSwaps = new List<Product_Swap__c>();
        List<SVMXC__Installed_Product__c> insertIPs = new List<SVMXC__Installed_Product__c>();
        List<SVMXC__RMA_Shipment_Order__c> insertRMAs = new List<SVMXC__RMA_Shipment_Order__c>();
        List<SVMXC__RMA_Shipment_Line__c> insertRMALines = new List<SVMXC__RMA_Shipment_Line__c>();
        String accountId;
     
        for(Product_Swap__c t: [select id, Swap_Now__c, Status__c, Previous_Installed_Product__c, Previous_Installed_Product__r.SVMXC__Site__c, Previous_Installed_Product__r.SVMXC__Street__c, Previous_Installed_Product__r.SVMXC__City__c, Previous_Installed_Product__r.SVMXC__State__c, Previous_Installed_Product__r.SVMXC__Country__c, Previous_Installed_Product__r.SVMXC__Zip__c, Stock_Location__c, Stock_Location__r.SVMXC__Street__c, Stock_Location__r.SVMXC__City__c, Stock_Location__r.SVMXC__Country__c, Stock_Location__r.SVMXC__Zip__c, Stock_Location__r.SVMXC__State__c,Product_Stock__c, Stocked_Serial__c, Stocked_Serial__r.SVMXC__Product__c, Stocked_Serial__r.Name, Work_Order__c, Work_Order__r.SVMXC__Company__c from Product_Swap__c where Id in: swapMap.keySet() AND Swap_Now__c=true AND Status__c='Open']){                        
            // insert new installed product
            SVMXC__Installed_Product__c newIP = new SVMXC__Installed_Product__c();
            newIP.SVMXC__Serial_Lot_Number__c = t.Stocked_Serial__r.Name;
            newIP.SVMXC__Status__c='Installed';
            newIP.SVMXC__Product__c = t.Stocked_Serial__r.SVMXC__Product__c;
            newIP.SVMXC__Company__c = t.Work_Order__r.SVMXC__Company__c;
            accountId = t.Work_Order__r.SVMXC__Company__c;
            insertIPs.add(newIP);           
            
            // create RMA record for previous installed product
            SVMXC__RMA_Shipment_Order__c newRMA = new SVMXC__RMA_Shipment_Order__c();
            newRMA.SVMXC__Company__c = t.Work_Order__r.SVMXC__Company__c;
            newRMA.SVMXC__Service_Order__c = t.Work_Order__c;
            newRMA.Installed_Product_Swap__c =  t.Previous_Installed_Product__c;
            newRMA.SVMXC__Source_Location__c = t.Stock_Location__c; //Previous_Installed_Product__r.SVMXC__Site__c;  
            newRMA.SVMXC__Source_Street__c = t.Stock_Location__r.SVMXC__Street__c;  //  Previous_Installed_Product__r
            newRMA.SVMXC__Source_City__c = t.Stock_Location__r.SVMXC__City__c; // Previous_Installed_Product__r
            newRMA.SVMXC__Source_State__c = t.Stock_Location__r.SVMXC__State__c; // Previous_Installed_Product__r
            newRMA.SVMXC__Source_Country__c = t.Stock_Location__r.SVMXC__Country__c; // Previous_Installed_Product__r
            newRMA.SVMXC__Source_Zip__c = t.Stock_Location__r.SVMXC__Zip__c; // Previous_Installed_Product__r
            newRMA.SVMXC__Destination_Location__c = null;
            insertRMAs.add(newRMA);                         
        }
        if(insertIPs.size()>0) insert insertIPs;
        if(insertRMAs.size()>0) insert insertRMAs;
        for(SVMXC__RMA_Shipment_Order__c rma: insertRMAs){
            SVMXC__RMA_Shipment_Line__c line = new SVMXC__RMA_Shipment_Line__c(SVMXC__RMA_Shipment_Order__c=rma.id);
            line.SVMXC__Serial_Number__c = rma.Installed_Product_Swap__c;
            line.SVMXC__Line_Status__c ='Open';
            insertRMALines.add(line);
        }
        if(insertRMALines.size()>0) insert insertRMALines;
        
        List<PrevNewIP> PrevNewIPs = new List<PrevNewIP>();
                
        for(Product_Swap__c t: [select id, Account__c, Swap_Now__c, Status__c, Previous_Installed_Product__c, Stock_Location__c, Product_Stock__c, Stocked_Serial__c, Stocked_Serial__r.Name, Stocked_Serial__r.SVMXC__Product__c, Work_Order__c, Work_Order__r.SVMXC__Company__c from Product_Swap__c where Id in: swapMap.keySet() ]){
            Boolean needIPupdate = false;       
            for(SVMXC__Installed_Product__c i:insertIPs){
                //update Product Swap Record            
                if(i.SVMXC__Serial_Lot_Number__c==t.Stocked_Serial__r.Name){                
                    t.New_Installed_Product__c = i.Id;
                    t.Swap_Now__c = false;
                    t.Status__c = 'Swapped';
                    t.Date_Time_Swapped__c = System.now();
                    needIPUpdate=true;
                    PrevNewIP p1 = new PrevNewIP();
                    p1.previousIP = new SVMXC__Installed_Product__c(id=t.Previous_Installed_Product__c);
                    p1.newIP = new SVMXC__Installed_Product__c(id=t.New_Installed_Product__c, SVMXC__Product__c=t.Stocked_Serial__r.SVMXC__Product__c);
                    p1.pswap = t;
                    p1.workorder = new SVMXC__Service_Order__c(id=t.Work_Order__c);
                    PrevNewIPs.add(p1);
                }           
            }
            
            if(t.Account__c!=t.Work_Order__r.SVMXC__Company__c){
                t.Account__c=t.Work_Order__r.SVMXC__Company__c;
                needIPUpdate=true;
            }
            if(needIPUpdate==true){updateSwaps.add(t);}
        }
        if(updateSwaps.size()>0)update updateSwaps;
    
        // Configuration Swap
        System.debug('swap config');
        List<SVMXC__Installed_Product__c> config1 = new List<SVMXC__Installed_Product__c>();
        List<SVMXC__Installed_Product__c> config2 = new List<SVMXC__Installed_Product__c>();
        
        Map<id, SVMXC__Installed_Product__c> ipMap = new Map<id,SVMXC__Installed_Product__c>();
        for(PrevNewIP i: PrevNewIPs){
            ipMap.put(i.previousIP.id, i.previousIP);
        } 
        for(SVMXC__Installed_Product__c ip:[select id, Name, SVMXC__Top_Level__c, SVMXC__Parent__c from SVMXC__Installed_Product__c where id in:ipMap.keySet() OR SVMXC__Top_Level__c in: ipMap.keySet() OR SVMXC__Parent__c in: ipMap.keySet()]){
            System.debug('enter ip');           
            for(PrevNewIP table: PrevNewIPs){
                SVMXC__Installed_Product__c theNewIP = new SVMXC__Installed_Product__c(id=table.newIP.id);
                Boolean doSwap1 = false, doSwap2 = false;
                // swap current Products' top level and parent level
                if(ip.id==table.pswap.Previous_Installed_Product__c){
                    theNewIP.SVMXC__Top_Level__c=ip.SVMXC__Top_Level__c;
                    theNewIP.SVMXC__Parent__c = ip.SVMXC__Parent__c;
                    ip.SVMXC__Top_Level__c = null;
                    ip.SVMXC__Parent__c = null;
                    doSwap1=true;
                }
                            
                // swap Child products Top Level for the newIP
                if(ip.SVMXC__Top_Level__c==table.pswap.Previous_Installed_Product__c){
                    ip.SVMXC__Top_Level__c = table.newIP.id;
                    doSwap2=true;
                }
                // swap Child products Parent Level for the newIP
                if(ip.SVMXC__Parent__c==table.pswap.Previous_Installed_Product__c){                 
                    ip.SVMXC__Parent__c = table.newIP.id;
                    doSwap2=true;
                }
                Boolean alreadyInConfig1=false;
                for(SVMXC__Installed_Product__c a: config1){
                    if(a.id==theNewIP.id){alreadyInConfig1=true;}
                    if(a.id==ip.id){alreadyInConfig1=true;}
                }
                if(doSwap1==true && alreadyInConfig1==false) {config1.add(theNewIP); config1.add(ip);}
                
                Boolean alreadyInConfig2=false;
                for(SVMXC__Installed_Product__c a: config2){
                    if(a.id==ip.id){alreadyInConfig2=true;}
                }
                if(doSwap2==true && alreadyInConfig2==false) {config2.add(ip);} 
                                
            }   
        }
        if(config1.size()>0) update config1; 
        if(config2.size()>0) update config2;
        
        //Generate work detail in work order
        List<SVMXC__Service_Order_Line__c> insertLines = new List<SVMXC__Service_Order_Line__c>();
        RecordType rectype = [select id from RecordType where SobjectType='SVMXC__Service_Order_Line__c' AND Name like '%Usage%' limit 1]; 
        for(PrevNewIP p2: PrevNewIPs){
            SVMXC__Service_Order_Line__c sol = new SVMXC__Service_Order_Line__c(SVMXC__Service_Order__c=p2.workorder.id);
            sol.RecordTypeId = rectype.id;
            sol.SVMXC__Product__c = p2.newIP.SVMXC__Product__c;
            sol.SVMXC__Serial_Number__c = p2.newIP.id;
            sol.SVMXC__Line_Type__c = 'Parts';
            sol.SVMXC__Actual_Quantity2__c = 1;
            insertLines.add(sol);
        }
        if(insertLines.size()>0) insert insertLines;
    }
}