public with sharing class CV_IP_Controller {

    // or whatever you need to return a valid key to the component
    public string forcekey { get { return 'ABQIAAAAB0wwxr_S8iKOQA_rHFtvlhQrroEcTVXxNCBMYghN-z6V4Vps5BRsJnPQt8nVzwKal0A9wognXYZwLQ'; }}
    public Integer chatterCount {get; set; }
    SObject[] objList = new SObject[]{};
    Map<Id, Integer> g_ip_map = new Map<Id, Integer>();
    Map<Id, SVMXC__Installed_Product__Feed> g_last_post = new Map<Id, SVMXC__Installed_Product__Feed>();
    
    public String fromDate {get; set;}
    public String toDate {get; set;}
    public String volumeObj {get; set;}
    public String minChatter {get; set;}
    
    public CV_IP_Controller() {
        volumeObj = 'ips';
        refresh();
    }
    
    private void doQuery(String obj) {
        Datetime startDate = Datetime.now().addMonths(-2);
        Datetime endDate = Datetime.now();
        String strDate = fromDate + ' 00:00 AM';
        if (fromDate != null && fromDate.length() > 0)
            startDate = Datetime.parse(strDate);
        strDate = toDate + ' 11:59 PM';
        if (toDate != null && toDate.length() > 0)
            endDate = Datetime.parse(strDate);
        
        String selClause = 'Select ' + ( obj == 'Account'? 'ParentId': 'Parent.Account.Id') + ' , count(Id) from ';
        String whereClause = ' Where FeedPost.Type = \'TextPost\' and CreatedDate >= :startDate and CreatedDate <= :endDate Group By ' 
                                +  ( obj == 'Account'?'ParentId':'Parent.Account.Id' );
        String Query = selClause + (obj == 'Account'? 'AccountFeed': obj == 'Case'? 'CaseFeed': 'OpportunityFeed')
                                 + whereClause;
    
        if (obj == 'ips') {
            Query = 'Select Parent.SVMXC__Company__r.Id, count(Id) from SVMXC__Installed_Product__Feed ' +
                    ' Where FeedPost.Type = \'TextPost\' and CreatedDate >= :startDate and CreatedDate <= :endDate Group By' +
                    ' Parent.SVMXC__Company__r.Id';
        }
        AggregateResult[] groupedResults = Database.query(Query);
        Integer val;
        Id l_id;
        Integer i;

        for (AggregateResult ag : groupedResults) {
            if (Obj == 'Account')
                l_id = (Id) ag.get('ParentId');
            else
                l_id = (Id) ag.get('Id');
            i = g_ip_map.get(l_id);
            val = (Integer) ag.get('expr0');
            if (i == null) i = 0;
            g_ip_map.put(l_id, i + val);
        }
        
    }
    
    public PageReference refresh() {
        Set <Id> ip_ids = new Set<Id>();
        g_ip_map.clear();
        if (volumeObj == 'All') {
            doQuery('Account');
            doQuery('Case');
            doQuery('Opportunity');
        } else
            doQuery(volumeObj);
        
        ip_ids = g_ip_map.keySet(); 
        objList = [select Id, name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode
            from Account 
            where Id in :ip_ids
            ];
        return null;        
    }

    public void setIPData(String ipd) {}
    public String getIPData() {
        String billingStreet, billingCity, billingState, billingPostalCode, billingCountry;
        String jsonString = '{"ips" : [';
        String address;
        Integer cnt = 0;
        for (SObject ip: objList) {
            if (ip.get('BillingStreet') != null)
                billingStreet = ((String) ip.get('BillingStreet')).split('\n')[0];
            else
                billingStreet = '';
            if (ip.get('BillingCity') != null)
                billingCity = ((String) ip.get('BillingCity')).replace('\n', ' ');
            else
                billingCity = '';
            billingState = ip.get('BillingState') != null? (String) ip.get('BillingState'):'';
            billingPostalCode = ip.get('BillingPostalCode') != null? (String) ip.get('BillingPostalCode'):'';
            billingCountry = ip.get('BillingCountry') != null? (String) ip.get('BillingCountry'):'';

            address = ' ' + billingStreet + ', ' + billingCity + ', ' +  billingState + ' - ' + billingPostalCode +  ', ' +  billingCountry;
            if (cnt++ > 0)
                jsonString += ',';
            jsonString += '{"name": "' + ip.get('name') + ' : ' + address + '",';
            jsonString += '"lat": "'  + '",';
            jsonString += '"lon": "' + '",';
            jsonString += '"aid": "' + ip.Id + '",';
            jsonString += '"street": "' + billingStreet + '",';
            jsonString += '"city": "' + billingCity + '",';
            jsonString += '"state": "' + billingState + '",';
            jsonString += '"zip": "' + billingPostalCode + '",';
            jsonString += '"country": "' + billingCountry + '",';
            jsonString += '"chat_cnt": "' + g_ip_map.get(ip.Id) + '"}';
        }
        jsonString += ']}';
        return jsonString;
        // return '{"ips" : [{"name":"ip", "lat": "37.334304", "lon" : "-121.950796", "count" : "5"}]}';
    }
    
    public static testmethod void t1() {
        CV_IP_Controller c = new CV_IP_Controller();
        c.getIPData(); 
    }   
}