public with sharing class POLookupProducts {
	// Initial set of fields 
	String poId = System.currentPageReference().getParameters().get('id');
	SVMXC__RMA_Shipment_Order__c partorder; public SVMXC__RMA_Shipment_Order__c getpartorder(){return partorder;}
	List<SVMXC__RMA_Shipment_Line__c> partlines; public List<SVMXC__RMA_Shipment_Line__c> getpartlines(){ return partlines; }	
	SVMXC__Site__c location; public SVMXC__Site__c getlocation(){ return location;}
	List<SVMXC__Product_Stock__c> prodStocks; public List<SVMXC__Product_Stock__c> getprodStocks(){ return prodStocks; }
	public Id partlineid{get{return partlineid;} set{partlineid = value;}}
	public SVMXC__RMA_Shipment_Line__c partline{get{return partline;} set;}
	List<Product_Substitution_Addition__c> relatedproducts = new List<Product_Substitution_Addition__c>(); public List<Product_Substitution_Addition__c> getrelatedproducts(){ return relatedproducts; }	
	public String newproductId{get; set{newproductId = value;}}
	List<SVMXC__Product_Stock__c> SubStocks = new List<SVMXC__Product_Stock__c>(); public List<SVMXC__Product_Stock__c> getSubStocks(){ return SubStocks; }
	List<SVMXC__Product_Stock__c> AccessoryStocks = new List<SVMXC__Product_Stock__c>(); public List<SVMXC__Product_Stock__c> getAccessoryStocks(){ return AccessoryStocks; }
	public Boolean ConsiderLocation{get{if(ConsiderLocation==null)ConsiderLocation=false; return ConsiderLocation;}set;}
	List<Product_Substitution_Addition__c> SubProducts = new List<Product_Substitution_Addition__c>(); public List<Product_Substitution_Addition__c> getSubProducts(){ return SubProducts; }
	List<Product_Substitution_Addition__c> AccessoryProducts = new List<Product_Substitution_Addition__c>(); public List<Product_Substitution_Addition__c> getAccessoryProducts(){ return AccessoryProducts; }
	
	// Constructor
	public POLookupProducts(){
		this.POLookupProducts();		
	}
	public void POLookupProducts(){
		partorder = [select id, Name, SVMXC__Source_Location__c, SVMXC__Order_Status__c, (select id, Name, SVMXC__Expected_Quantity2__c, SVMXC__Actual_Quantity2__c, SVMXC__Line_Status__c, SVMXC__Product__c, SVMXC__Product__r.IsActive, SVMXC__Product__r.Name, SVMXC__RMA_Shipment_Order__r.Id, SVMXC__RMA_Shipment_Order__r.Name, SVMXC__RMA_Shipment_Order__r.SVMXC__Source_Location__c, SVMXC__RMA_Shipment_Order__r.SVMXC__Source_Location__r.Name from SVMXC__RMA_Shipment_Line__r) from SVMXC__RMA_Shipment_Order__c where id=:poId];					
		partlines = partorder.SVMXC__RMA_Shipment_Line__r;		
		if(partorder.SVMXC__Source_Location__c!=null && ConsiderLocation==true){
			IncludeLocationDetails();	
		} 
		//else { RerenderProducts();}			
	}	
	public void IncludeLocationDetails(){
		location = [select id, Name, (Select Id, Name, SVMXC__Quantity2__c, SVMXC__Product__c, SVMXC__Product__r.Name, SVMXC__Product__r.IsActive From SVMXC__Product_Stock__r where SVMXC__Status__c='Available') from SVMXC__Site__c where id=:partorder.SVMXC__Source_Location__c];
		prodStocks = location.SVMXC__Product_Stock__r;	
		
		// Get related product info
		Map<id, SVMXC__Product_Stock__c> prodMap = new Map<id,SVMXC__Product_Stock__c>();
		for(SVMXC__Product_Stock__c i: prodStocks){
			prodMap.put(i.SVMXC__Product__c, i);
		}	
		for(Product2 prod: [select id, (select id, Main_Product__c, Related_Product__c, Type__c from Child_Main_Product__r), (select id, Main_Product__c, Related_Product__c, Type__c from Child_Related_Product__r) from Product2 where Id in: prodMap.keySet()]){					
			for(Product_Substitution_Addition__c psa: prod.Child_Main_Product__r){
				Boolean InList=false;
				for(Product_Substitution_Addition__c temp: relatedproducts){
					if(temp.id==psa.id){InList=true;}
				}
				if(InList==false){relatedproducts.add(psa);}
			}
			for(Product_Substitution_Addition__c psa: prod.Child_Related_Product__r){
				Boolean InList1=false;
				for(Product_Substitution_Addition__c temp: relatedproducts){
					if(temp.id==psa.id){InList1=true;}
				}
				if(InList1==false){relatedproducts.add(psa);}
			}
		}			
	}
	public String rendervalue{get; set{rendervalue=value;}}
	public PageReference RerenderStock(){
		System.debug('rendervalue'+rendervalue);
		Map<id, Product_Substitution_Addition__c> prodMap = new Map<id,Product_Substitution_Addition__c>();
		for(Product_Substitution_Addition__c i: relatedproducts){ prodMap.put(i.Related_Product__c, i);}
		set<id> keys1 = prodMap.keyset();
		for(Product_Substitution_Addition__c i: relatedproducts){ prodMap.put(i.Main_Product__c, i);}
		set<id> keys2 = prodMap.keyset();
		System.debug('relatedproducts.size: '+relatedproducts.size());
		String qry = 'select id, Name, (Select Id, Name, SVMXC__Quantity2__c, SVMXC__Product__c, SVMXC__Product__r.Name, SVMXC__Product__r.IsActive  From SVMXC__Product_Stock__r where SVMXC__Status__c=\'Available\' AND (SVMXC__Product__c=\''+ rendervalue + '\' OR SVMXC__Product__c IN :keys1 OR SVMXC__Product__c IN :keys2)) from SVMXC__Site__c where id=\''+partorder.SVMXC__Source_Location__c+'\'';		
		System.debug('qry:' + qry); 
		location = Database.query(qry);
		prodStocks = location.SVMXC__Product_Stock__r;	
		if(partlineid!=null){
			for(SVMXC__RMA_Shipment_Line__c line: partlines){
				if(line.Id == partlineid){
					partline = line;
				}
			}			
		}
		// Get Main/Substitution Parts only
		SubStocks = new List<SVMXC__Product_Stock__c>();
		for(SVMXC__Product_Stock__c i:prodStocks){
			if(i.SVMXC__Product__c==rendervalue){
				SubStocks.add(i);
			}
			for(Product_Substitution_Addition__c psa:relatedproducts){
				if(psa.Related_Product__c==i.SVMXC__Product__c && psa.Type__c=='Substitution' && psa.Main_Product__c==partline.SVMXC__Product__c){
					System.debug('psa.Main_Product__c: '+psa.Main_Product__c);
					System.debug('psa.Related_Product__c: '+psa.Related_Product__c);
					System.debug('i.SVMXC__Product__c:'+i.SVMXC__Product__c);
					System.debug('psa.Type__c:'+psa.Type__c);
					SubStocks.add(i);
				}
			}
		}
		// Get Accessory Parts only
		AccessoryStocks = new List<SVMXC__Product_Stock__c>();
		for(SVMXC__Product_Stock__c i:prodStocks){			
			for(Product_Substitution_Addition__c psa:relatedproducts){
				if(psa.Related_Product__c==i.SVMXC__Product__c && psa.Type__c=='Accessory' && psa.Main_Product__c==partline.SVMXC__Product__c){
					System.debug('psa.Main_Product__c: '+psa.Main_Product__c);
					System.debug('psa.Related_Product__c: '+psa.Related_Product__c);
					System.debug('i.SVMXC__Product__c:'+i.SVMXC__Product__c);
					System.debug('psa.Type__c:'+psa.Type__c);
					AccessoryStocks.add(i);
				}
			}
		}	
		return null;
	}
	
	public void RerenderProducts(){
		if(partlineid!=null){
			for(SVMXC__RMA_Shipment_Line__c line: partlines){
				if(line.Id == partlineid){
					partline = line;
				}
			}			
		}
		System.debug('partline.SVMXC__Product__c:'+partline.SVMXC__Product__c);
		 
		Product2 p = [select id, IsActive, Description, (select id, Main_Product__r.IsActive, Related_Product__r.IsActive, Related_Product__r.Description, Main_Product__c, Related_Product__c, Type__c from Child_Main_Product__r), (select id, Main_Product__c, Related_Product__c, Type__c from Child_Related_Product__r) from Product2 where Id =: partline.SVMXC__Product__c];
		List<Product_Substitution_Addition__c> subsadds = p.Child_Main_Product__r;
		
		// Get Main/Substitution Parts only
		SubProducts = new List<Product_Substitution_Addition__c>();
		for(Product_Substitution_Addition__c i:subsadds){
			if(i.Type__c == 'Substitution'){
				SubProducts.add(i);
			}
		}
		
		// Get Accessory Parts only
		AccessoryProducts = new List<Product_Substitution_Addition__c>();
		for(Product_Substitution_Addition__c j:subsadds){
			if(j.Type__c == 'Accessory'){
				AccessoryProducts.add(j);
			}
		}
	}
	
	public PageReference SavePartLines(){
		update partlines;
		return null;
	}
	
	public PageReference DeleteLine(){
		if(partlineid!=null){
			for(SVMXC__RMA_Shipment_Line__c line: partlines){
				if(line.Id == partlineid){
					partline = line;
				}
			}			
		}
		delete partline;
		PageReference page = new PageReference('/apex/POLookupProducts?id='+poId);	
		page.setRedirect(true);	
		return page; 
	}
	public PageReference Cancel(){
		PageReference page = new PageReference('/'+poId);
		return page;
	}
	
	public PageReference UpdateProduct(){
		System.debug('  rendervalue: '+rendervalue);
		System.debug('  newproductid: '+newproductid);
		System.debug('  partlineid: '+partlineid);
		
		partline.SVMXC__Product__c = newproductId;
		update partline;
				
		PageReference page = new PageReference('/apex/POLookupProducts?id='+poId);		
		page.setRedirect(true);
		return page; 	
	}

	public PageReference AddAccessory(){
		System.debug('  rendervalue: '+rendervalue);
		System.debug('  newproductid: '+newproductid);
		System.debug('  partlineid: '+partlineid);
		
		SVMXC__RMA_Shipment_Line__c newpartline = new SVMXC__RMA_Shipment_Line__c();
		RecordType shipmentrecordtype = [select SobjectType, Name, Id From RecordType r where SobjectType='SVMXC__RMA_Shipment_Line__c' AND Name='Shipment'];
		newpartline.SVMXC__Product__c = newproductId;
		newpartline.RecordTypeId = shipmentrecordtype.id;
		newpartline.SVMXC__Expected_Quantity2__c = 1;
		newpartline.SVMXC__RMA_Shipment_Order__c = poId;
		insert newpartline;
				
		PageReference page = new PageReference('/apex/POLookupProducts?id='+poId);		
		page.setRedirect(true);
		return page; 	
	}	
	
	public static testmethod void t1(){
		SVMXC__RMA_Shipment_Order__c newrma = new SVMXC__RMA_Shipment_Order__c();
		insert newrma;
		//Test coverage for the SVMX_VF_ServiceReport visualforce page
        PageReference pageRef = Page.POLookupProducts;
        pageRef.getParameters().put('id',newrma.Id);
        Test.setCurrentPageReference(pageRef);
        
		POLookupProducts poclass = new POLookupProducts();
		//poclass.IncludeLocationDetails(); poclass.RerenderStock(); poclass.RerenderProducts();
		//poclass.SavePartLines(); poclass.DeleteLine();
		//poclass.getAccessoryProducts(); poclass.getAccessoryStocks(); poclass.getlocation(); poclass.getpartlines(); poclass.getpartorder();
		//poclass.getprodStocks(); poclass.getrelatedproducts(); poclass.UpdateProduct(); poclass.getSubProducts(); poclass.getSubStocks();
	}
}