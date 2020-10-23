<%@ page import = "  javax.servlet.*, javax.servlet.http.*, java.io.*, org.apache.lucene.analysis.*, org.apache.lucene.analysis.standard.StandardAnalyzer, org.apache.lucene.document.*, org.apache.lucene.index.*, org.apache.lucene.search.*, org.apache.lucene.queryParser.*, org.apache.lucene.demo.*, org.apache.lucene.demo.html.Entities, java.net.URLEncoder" %>

<%!
public String escapeHTML(String s) {
  s = s.replaceAll("&", "&amp;");
  s = s.replaceAll("<", "&lt;");
  s = s.replaceAll(">", "&gt;");
  s = s.replaceAll("\"", "&quot;");
  s = s.replaceAll("'", "&apos;");
  return s;
}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Search Page</title>
    </head>
    <body bgcolor="gray">
        <div align="center">
            <H1>My Search Engine!!!</H1>
        </div>
        <form name="search" action="results.jsp" method="get">
            <div align="center">
                <table>	
                <tr>
                    <td colspan="2">
                       <input name="query" size="60" placeholder="Enter Search String"/> 
                    </td> 
                </tr>
                <tr>
                    <td align="right">
                        <input type="submit" size="40" value="My Search"/>
                    </td>
                     <td align="left">
			<input type="button" value="All is here."/>
                    </td>
                </tr>
                
            </table>
            </div>
           
        </form>
<%
        boolean error = false;                  //used to control flow for error messages
        String indexName = "G:\\8th Semester\\Information Retrieval\\JSearchEngine\\JSearchEngine\\indexDirectory";       //local copy of the configuration variable
        IndexSearcher searcher = null;          //the searcher used to open/search the index
        Query query = null;                     //the Query created by the QueryParser
        Hits hits = null;                       //the search results
        int startindex = 0;                     //the first index displayed on this page
        int maxpage    = 50;                    //the maximum items displayed on this page
        String queryString = null;              //the query entered in the previous page
        String startVal    = null;              //string version of startindex
        String maxresults  = null;              //string version of maxpage
        int thispage = 0;                       //used for the for/next either maxpage or
                                                //hits.length() - startindex - whichever is
                                                //less

        try {
          searcher = new IndexSearcher(indexName);      //create an indexSearcher for our page
                                                        //NOTE: this operation is slow for large
                                                        //indices (much slower than the search itself)
                                                        //so you might want to keep an IndexSearcher 
                                                        //open
                                                        
        } catch (Exception e) {                         //any error that happens is probably due
                                                        //to a permission problem or non-existant
                                                        //or otherwise corrupt index
%>
                <p>ERROR opening the Index - contact sysadmin!</p>
                <p>Error message: <%=escapeHTML(e.getMessage())%></p>   
<%                error = true;                                  //don't do anything up to the footer
        }
%>
<%
       if (error == false) {                                           //did we open the index?
                queryString = request.getParameter("query");           //get the search criteria
                startVal    = request.getParameter("startat");         //get the start index
                maxresults  = request.getParameter("maxresults");      //get max results per page
                try {
                        maxpage    = Integer.parseInt(maxresults);    //parse the max results first
                        startindex = Integer.parseInt(startVal);      //then the start index  
                } catch (Exception e) { } //we don't care if something happens we'll just start at 0
                                          //or end at 50

                

                if (queryString == null)
                        throw new ServletException("no query "+       //if you don't have a query then
                                                   "specified");      //you probably played on the 
                                                                      //query string so you get the 
                                                                      //treatment
%>
     
<%
                Analyzer analyzer = new StandardAnalyzer();           //construct our usual analyzer
                try {
                        QueryParser qp = new QueryParser("contents", analyzer);
                        query = qp.parse(queryString); //parse the 
                } catch (ParseException e) {                          //query and construct the Query
                                                                      //object
                                                                      //if it's just "operator error"
                                                                      //send them a nice error HTML
                                                                      
%>
<h2 style="alignment-adjust: central" align="center"> Error while parsing query. Please Enter something to search.</h2>
<%
                        error = true;                                 //don't bother with the rest of
                                                                      //the page
                }
        }
%>
<%
        if (error == false && searcher != null) {                     // if we've had no errors
                                                                      // searcher != null was to handle
                                                                      // a weird compilation bug 
                thispage = maxpage;                                   // default last element to maxpage
                hits = searcher.search(query);                        // run the query 
                if (hits.length() == 0) {                             // if we got no results tell the user
%>
    <h2 style="color: black; alignment-adjust: central" align="center">You are searching for "<%=queryString%>".</h2>
    <h2 style="color: red; alignment-adjust: central" align="center"> Sorry!!! No results found for "<%=queryString%>". </h2>
<%
                error = true;                                        // don't bother with the rest of the
                                                                     // page
                }
        }

        if (error == false && searcher != null) {                   
%>
<div  style="height: 100%; width: 70%; alignment-adjust: central; margin-left: 15%; color: white;border-left-color: black; border-right-color: black ">
            <div>
                <p>
                    <td>Searching For <span style="color: green;font: bold">"<%=queryString%>"</span>.</td>
                </p>
                <p>
                    <td>Results Found in <span style="color: green;font: bold"><%=hits.length()%> </span>documents.</td>
                </p>
            </div>

<%
                if ((startindex + maxpage) > hits.length()) {
                        thispage = hits.length() - startindex;      // set the max index to maxpage or last
                }                                                   // actual search result whichever is less

                for (int i = startindex; i < (thispage + startindex); i++) {  // for each element
%>
                <div>
<%
                        Document doc = hits.doc(i);                    //get the next document 
                        String doctitle = doc.get("title");            //get its title
                        String path = doc.get("path");  
                        String url = "";//get its path field
                     
                        url += path.substring(path.indexOf("web")+4);
                        url =  url.replace('\\', '/');
                        if (url != null && url.startsWith("../webapps/")) { // strip off ../webapps prefix if present
                                url = url.substring(10);
                        }
                        if ((doctitle == null) || doctitle.equals("")) //use the path if it has no title
                                doctitle = url;
                                                                       //then output!
%>
                        <div>
                            <h3><a href="<%=url%>" target="_blank"><%=doctitle%></a></h3>
                            <p style="font-size: 10px"><%=path%></p>
                            <p></p>
                            <p><%=doc.get("summary")%> </p>
                        </div>
                </div>
<%
                }
%>
<%                if ( (startindex + maxpage) < hits.length()) {   //if there are more results...display 
                                                                   //the more link

                        String moreurl="results.jsp?query=" + 
                                       URLEncoder.encode(queryString) +  //construct the "more" link
                                       "&amp;maxresults=" + maxpage + 
                                       "&amp;startat=" + (startindex + maxpage);
%>
                <div>
                        <p><a href="<%=moreurl%>">More Results>></a></p>
                </div>
<%
                }
%>
            </div>

<%       }                                            //then include our footer.
         if (searcher != null)
                searcher.close();
%>
        </div>
  </body>
</html>  

