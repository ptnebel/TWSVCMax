public with sharing class ChatterClass {
	//   /apex/Chatter_Quick_Search?core.apexpages.devmode.url=1
	public String SearchText{get;set;}
	public PageReference pref{get;set;}
	public String stringUrl{get;set;}
	public void doSearch(){ //PageReference	
		System.debug('SearchText:'+SearchText);
		SearchText = SearchText.replace('#', '');
		stringUrl = '/_ui/common/search/client/ui/UnifiedSearchResults?str='+SearchText+'*#!/initialViewMode=feeds&str='+SearchText+'*';
		//  /_ui/common/search/client/ui/UnifiedSearchResults#!/initialViewMode=feeds&str=
		//pref = new PageReference('/_ui/common/search/client/ui/UnifiedSearchResults?str='+SearchText+'*#/initialViewMode=feeds&str='+SearchText+'*');		
		//pref.setRedirect(true);
		//System.debug('pref: '+pref);
		//return pref;   commented out as we want the VF page to control the Search URL page
	}
	
}