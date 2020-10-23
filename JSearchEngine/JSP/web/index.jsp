
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Search Page</title>
    </head>
    <body bgcolor="gray">
        <div align="center">
            <H1>Welcome to My Search Engine!!!</H1>
        </div>
        <form name="search" action="results.jsp" method="get">
            <div align="center">
                <table>	
                    <tr>
                        <td colspan="2">	
                            <input name="query" size="60"  placeholder="Enter Search String"/>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <input type="submit" size="40"value="My Search"/>
                        </td>
                        <td align="left">
                            <input type="button" value="All is here."/>
                        </td>
                    </tr>
                </table>
            </div>
        </form>
    </body>
</html>
