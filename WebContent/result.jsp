<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="functions.*" %>

<%@ page import="org.apache.http.*" %>
<%@ page import="twitter4j.*" %>
<%@ include file="twitter.jsp" %>

<%!
// 쿠키 호출 메서드
private void search(String str) {
	
}

private String removePunctuations(String str) {
    return str.replaceAll("\\p{Punct}|\\p{Digit}", "");
}

public static String fncDeCode(String param)
{
	StringBuffer sb= new StringBuffer();
	int pos= 0;
	boolean flg= true;
	
	if(param!=null)
	{
		if(param.length()>1)
		{
			while(flg)
			{
			String sLen= param.substring(pos,++pos);
			int nLen= 0;
		
			try
			{
				nLen= Integer.parseInt(sLen);
			}
			catch(Exception e)
			{
				nLen= 0;
			}
	
			String code= "";
			if((pos+nLen)>param.length())
			code= param.substring(pos);
			else
			code= param.substring(pos,(pos+nLen));
	
			pos+= nLen;
	
			sb.append(((char) Integer.parseInt(code)));
	
			if(pos >= param.length())
			flg= false;
			}
		}
	}
	else
	{
		param= "";
	}
	
	return sb.toString();
}

public static boolean filtering(String s) {
	boolean check = false;
	

		//String s = new String(tweet.getText());
		//if(s.contains("1383")) check = true;
		if(s.contains("싸롱")) check = true;
		if(s.contains("풀싸롱")) check = true;
		if(s.contains("강남풀싸롱")) check = true;
		if(s.contains("오피")) check = true;
		if(s.contains("바둑이")) check = true;
		//if(s.contains("https://t.co/")) check = true;
		if(s.contains("강남스마트")) check = true;
		if(s.contains("강남두바이")) check = true;
		if(s.contains("역삼포커스")) check = true;
		if(s.contains("강남더블업")) check = true;
		if(s.contains("강남풀미러")) check = true;
		if(s.contains("역삼힐링")) check = true;
		if(s.contains("강남미러룸")) check = true;
		if(s.contains("강남힐링")) check = true;
		if(s.contains("도우미주점")) check = true;
		if(s.contains("사설토토")) check = true;
		if(s.contains("스포츠토토")) check = true;
		if(s.contains("사설토토사이트추천")) check = true;
		if(s.contains("네임드사다리사이트")) check = true;
		if(s.contains("네임드사다리")) check = true;
		if(s.contains("사다리사이트")) check = true;
		if(s.contains("사다리놀이터추천")) check = true;
		if(s.contains("바카라")) check = true;
		if(s.contains("풀사롱")) check = true;
		if(s.contains("소라넷")) check = true;
		if(s.contains("카지노")) check = true;
		if(s.contains("야동")) check = true;
		if(s.contains("바둑이")) check = true;
		if(s.contains("토토")) check = true;
		if(s.contains("추천인")) check = true;
		//if(s.contains("강남스마트")) check = true;
		//if(s.contains("강남스마트")) check = true;
		
		//if(s.contains("MAMAredcarpet")) check = true;
		//if(s.contains("MAMAredcarpert")) check = true;
			
	return check;
}
 

%>






<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Olleh 데이터 마이닝 엔진 - result : <%=fncDeCode((String)session.getAttribute("keyword")) %></title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
<script type="text/javascript">
var list;
$(document).ready(function() { 
	$.ajax({
        url : "http://apis.daum.net/search/image",
        dataType : "jsonp",
        type : "post",
        jsonp : "callback",
        data : {
            apikey : "e1c888472c479ebcd37beb62c5309681", //다음 API KEY 입력
            q : $("#keyword").val(),             // search keyword
            result : "20",                 // result set length
            //pageno : $("#pageno").val(),   // pageNo
            output : "json"                // JSONP type format json
        },
        success : function(r){
            list = r.channel.item;
            var fr = "";
            for(var i in list) {
                fr += "<a href=\""+ list[i].image +"\">"+
                      "<img src=\""+ list[i].thumbnail +"\"></a>";
            }
            //fr = "<div data-nav='thumbs'>" + fr + "</div>";
            $("#fr").html(fr);
            //$("#fr div").fotorama({width:720,height:480});
           
            //$("#pageno").val(parseInt($("#pageno").val())+1);
            //return list;

        }
    });
    return false;

}); 
</script>

<script>



function formSubmit(key){
	var fm=document.frm;
	frm.keyword.value=fncEnCode(key);
	fm.action='search.jsp'; 
    fm.method='post';
    
    fm.submit();
} 





function fncEnCode(param)
{
	var encode = '';
	
	for(i=0; i<param.length; i++)
	{
		var len  = ''+param.charCodeAt(i);
		var token = '' + len.length;
		encode  += token + param.charCodeAt(i);
	}
	
	return encode;
}



function fncSubmit()
{
    var fm=document.frm;
    
    //var keyword=document.createElement("input");
    //keyword.name="keyword";
    frm.keyword.value=fncEnCode(frm.keyword_box.value);
    frm.keyword2.value=fncEnCode(" " + frm.keyword_box2.value);
	//fm.appendChild(keyword);
    
    fm.action="search.jsp"; 
    fm.method="post";
    
    fm.submit();
}


</script>

</head>
<body>
<div align="center">
<h1 style="font-size:30pt">Olleh 데이터 마이닝 엔진</h1>
<br><br>
<form name="frm" method="post" onKeydown="javascript:if(event.keyCode == 13) fncSubmit();">
	검색어 : 
	<input type="text" size="30" name="keyword_box">
	추가(+)/제거(-)<input type="text" size="30" name="keyword_box2"><br>
	<input type='submit' name="Search" value="트위터 검색" onclick='javascript:fncSubmit();'>
	<select name="lang">
		<option value="ko">한국어</option>
		<option value="en">영어</option>
		<option value="zh">중국어</option>
		<option value="ja">일본어</option>
	</select>
	<input type="checkbox" name="tistory_post" value="true"> 티스토리 포스팅
	<input type="text" size="5" name="repeat">회 반복
	<input type="checkbox" name="urlentity" value="true"> URL Entity 찾기
	<input type="hidden" name="keyword">
	<input type="hidden" name="keyword2">
	
</form>
<br><br>
 <%=session.getAttribute("tistory_post") %>


검색한 키워드 리스트 : <%=session.getAttribute("keywordList") %>

<%


	request.setCharacterEncoding("EUC-KR");
	String tags = "";
	String title_side = "";
	int tag_count = 0;
	int MINIMUM_WORD_COUNT = 2;
	@SuppressWarnings("unchecked")
	ArrayList<WordCount> result = (ArrayList<WordCount>)session.getAttribute("result");
	@SuppressWarnings("unchecked")
	List<Status> tweets = (List<Status>)session.getAttribute("tweets");
	
	%><table border='1' align="center" width='1000'>
	<tr width='1000'><td width='1000'><%
	
	for (WordCount wc : result) {
		if (wc.n < MINIMUM_WORD_COUNT) break;
		if (wc.word.contains("http")) continue;
		if (wc.word.contains(fncDeCode((String)session.getAttribute("keyword")))) continue;
		if(filtering(wc.word)) continue;
		if(tag_count++ < 30) tags = tags + wc.word + ",";
		if(tag_count < 10) title_side = title_side + wc.word + ", ";
		else if(tag_count == 10) title_side = title_side + wc.word;
		
		%><font style="font-size:<%=wc.n%>pt">
		<a href='#' onclick='formSubmit("<%=wc.word%>")'><%=wc.word%></a></font>,<%
	
		
	}
	
	%> 
	</td></tr>
	</table>
	
	<br><br><br> </div>
	<%
	ArrayList<String> PhotoList = new ArrayList<String>();
	
	String tistory_content = "";
	for (Status tweet : tweets) {
		
		String s = new String(tweet.getText());
		
		//if(filtering(s)) continue;
		
		if(tweet.getMediaEntities().length != 0)
		{
			//System.out.println("1");
			for(MediaEntity me : tweet.getMediaEntities())
			if(me.getType().equals("photo")) {
				//System.out.println("2");
				if(!PhotoList.contains(me.getMediaURL())) {
					PhotoList.add(me.getMediaURL());
					
					
					
					//PhotoList.add(tweet.getMediaEntities()[0].getDisplayURL());
					//System.out.println(tweet.getMediaEntities()[0].getMediaURL());
				}
			}
			
				
			//System.out.println("media skip");
		
			//System.out.println("media");
			//System.out.println(tweet.getMediaEntities()[0].getType());
		}
		
		/* URL 찾기 기능
		if((String)session.getAttribute("urlentity") == null)
		if(tweet.getURLEntities().length != 0) {
			//System.out.print("2");
			continue;
		}
		*/
		
		
		
		if(tweet.isRetweet() == true) continue;
		//if(tweet.getText().contains() continue;
		
		
		//if(s.contains("1383")) continue;
		//if(tweet.getUser().getScreenName().contains(new String("power"))) continue;
		//s = s.replaceAll("싸롱", "");
		//CharSequence str = "69";
		//if(tweet.getUser().getScreenName().contains(str)) continue;
		//if(s.contains(str)) continue;
		//if(s.contains("강남풀싸롱")) continue;
		//if(s.contains("오피")) continue;
		//if(s.contains("성인")) continue;
		//if(s.contains("바둑이")) continue;
		//if(s.contains("쌀롱")) continue;
		//if(s.contains("")) continue;
		
		//if(tweet.getUser().getScreenName().equals("gangnam69power")) continue;
		
		
		//if(s.contains("https://t.co/")) continue;
		
		/*
		while(s.contains("https://t.co/")) {
			//System.out.println(s);
			int i = s.indexOf("https://t.co/");
			System.out.println(s);
			
			//s = s.replaceAll("https://t.co/", "");
			s = s.replace(s.substring(i, i+23), "");
			//s = s.replace("https", " ");
			
			System.out.println(s);
			
			
		}
		*/
		//s = s.replaceAll("@", "");
		//s = s.replaceAll("#", "");
		s = s.replaceAll("ㅋ", "");
		s = s.replaceAll("ㅎ", "");
		s = s.replaceAll("ㅠ", "");
		s = s.replaceAll("ㅜ", "");
		s = s.replaceAll("ㅡ", "");
		s = s.replaceAll("ㅇ", "");
		//s = s.replaceAll("(", "");
		//s = s.replaceAll(")", "");
		//s = s.replaceAll("[", "");
		//s = s.replaceAll("]", "");
		s = s.replace('(', ' ');
		s = s.replace(')', ' ');
		s = s.replace('[', ' ');
		s = s.replace(']', ' ');
		s = s.replaceAll("RT", "");
		
		
		
		%><br><%
		//out.println(tweet.getText() + ".");
		out.println(s + ".");
		
		//tistory_content = tistory_content + s + ".<br>";
	}
	
	%>
	
	
	
	 <div align="left">
	
	
	<table style="border-collapse: collapse;" align="center">
	<%
	
	tistory_content = tistory_content + "<div class=\"tt_article_useless_p_margin\"><table align=\"center\" style=\"color: rgb(0, 0, 0); font-family: 'Malgun Gothic'; border-collapse: collapse; width:100%;\"><tbody>";
	
	
	
	
	int item_num = 0; 
	int photo_position = 0;
	for (Status tweet : tweets) {
		if(tweet.isRetweet() == true) continue;
		String s = new String(tweet.getText());
		
		//if(s.contains("https://t.co/")) continue;
		//if(filtering(s)) continue;
		
		
		
		
		
		if((String)session.getAttribute("urlentity") == null)
		if(tweet.getURLEntities().length != 0) {
			//System.out.print("2");
			continue;
		}
		
		
		/*
		if(s.contains("https://t.co/")) {
			//System.out.println(s);
			int i = s.indexOf("https://t.co/");
			
			System.out.println(s);
			
			//s = s.replaceAll("https://t.co/", "");
			String address = s.substring(i, i+23);
			s = s.replace(address, "<a href=\"" + address + "\" target=\"_blank\">" + address + "</a>");
			//s = s.replace("https", " ");
			
			System.out.println(s);
			
		}
		*/
		
		while(s.contains("https://t.co/")) {
			//System.out.println(s);
			int i = s.indexOf("https://t.co/");
			//System.out.println(s);
			
			//s = s.replaceAll("https://t.co/", "");
			s = s.replace(s.substring(i, i+23), "");
			//s = s.replace("https", " ");
			
			//System.out.println(s);
			
			
		}
		
		
		//s = s.replaceAll("@", "");
		//s = s.replaceAll("#", "");
		s = s.replaceAll("ㅋ", "");
		s = s.replaceAll("ㅎ", "");
		s = s.replaceAll("ㅠ", "");
		s = s.replaceAll("ㅜ", "");
		s = s.replaceAll("ㅡ", "");
		s = s.replaceAll("ㅇ", "");
		//s = s.replaceAll("(", "");
		//s = s.replaceAll(")", "");
		//s = s.replaceAll("[", "");
		//s = s.replaceAll("]", "");
		s = s.replace('(', ' ');
		s = s.replace(')', ' ');
		s = s.replace('[', ' ');
		s = s.replace(']', ' ');
		s = s.replaceAll("RT", "");
		
		tistory_content = tistory_content + "<tr><td width=\"60\" align=\"center\" style=\"border: 1px solid rgb(204, 204, 204); font-size: 10px; padding: 1px;\">";
		tistory_content = tistory_content + "<a href=\"https://twitter.com/" + (String)tweet.getUser().getScreenName() + "\" target=\"_blank\" title=\"" + tweet.getUser().getScreenName() + "\"> ";
		tistory_content = tistory_content + "<img src=\"" + tweet.getUser().getProfileImageURL() + "\" border=0 title=\"" + tweet.getUser().getName() + "&#13;@" + tweet.getUser().getScreenName() + "\" alt=\"" + tweet.getUser().getScreenName() + "\" onerror=\"this.src='http://abs.twimg.com/sticky/default_profile_images/default_profile_4_normal.png';\"><br>";
		//tistory_content = tistory_content + "@" + (String)tweet.getUser().getScreenName();
		tistory_content = tistory_content + "</a></td><td style=\"border: 1px solid rgb(204, 204, 204); padding: 5px;\">";
		tistory_content = tistory_content + "<font title=\"" + tweet.getCreatedAt() + "\" style=\"CURSOR:hand;\">" + s + "</font>";
		tistory_content = tistory_content + "</td> </tr>";
		
		item_num++;
		if(item_num == 14) tistory_content = tistory_content + "</tbody></table><table align=\"center\" style=\"color: rgb(0, 0, 0); font-family: 'Malgun Gothic'; border-collapse: collapse;\"><tbody><tr><td colspan=\"2\" style=\"text-align:center; padding:1px;\"><p style=\"text-align:center;\"><style>.twitsideAd { width: 336px; height: 280px; margin-top: 15px; margin-bottom: 15px; }@media(max-width: 768px) { .twitsideAd { width: 300px; height: 250px; margin-top: 15px; margin-bottom: 15px; } }</style><script async=\"\" src=\"//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js\"></script><ins class=\"adsbygoogle twitsideAd\" style=\"display:inline-block\" data-ad-client=\"ca-pub-8716569569929004\" data-ad-slot=\"4334296770\" data-ad-format=\"auto\"></ins><script>(adsbygoogle = window.adsbygoogle || []).push({});</script></p></td></tr></tbody></table><table align=\"center\" style=\"color: rgb(0, 0, 0); font-family: 'Malgun Gothic'; border-collapse: collapse; width:100%\"><tbody>";
		else if((item_num % 7) == 0){
			//System.out.println("1");
			//tistory_content = tistory_content + "</tbody></table><p style=\"text-align: center; clear: none; float: none;\"><span class=\"imageblock\" style=\"display:inline-block;;height:auto;max-width:100%\"><span dir=\"";
		
			//tistory_content = tistory_content + tweet.getUser().getOriginalProfileImageURL() + "\" rel=\"lightbox\" target=\"_blank\"><img src=\"";
			//tistory_content = tistory_content + tweet.getUser().getOriginalProfileImageURL() + "\" style=\"max-width:100%;height:auto\"></span></span></p><table align=\"center\" style=\"color: rgb(0, 0, 0); font-family: 'Malgun Gothic'; border-collapse: collapse;\"><tbody>";
			if(photo_position < PhotoList.size()) {
				%><tr><td colspan="2"><div style="text-align:center;"><img src="<%=PhotoList.get(photo_position).toString()%>" border=0 alt="<%=fncDeCode((String)session.getAttribute("keyword")) + ", " + title_side%>"></div></td><tr><%
						tistory_content = tistory_content + "</tbody></table><p style=\"text-align: center; clear: none; float: none;\"><span class=\"imageblock\" style=\"display:inline-block;;height:auto;max-width:100%\"><span dir=\"";
						
						tistory_content = tistory_content + PhotoList.get(photo_position).toString() + "\" rel=\"lightbox\" target=\"_blank\"><img src=\"";
						tistory_content = tistory_content + PhotoList.get(photo_position).toString() + "\" style=\"max-width:100%;height:auto\" alt=\"" + fncDeCode((String)session.getAttribute("keyword")) + ", " + title_side + "\"></span></span></p><table align=\"center\" style=\"color: rgb(0, 0, 0); font-family: 'Malgun Gothic'; border-collapse: collapse;\"><tbody>";
			
						photo_position++;
						
						//System.out.print(item_num + " ");
			}
		}
		
		
		%> <tr>
		<td style="border: 1px solid #ccc; font-size:10px; padding:1px;" width='60' align='center'>
		<a href="https://twitter.com/<%=tweet.getUser().getScreenName() %>" target="_blank" title="<%=tweet.getUser().getScreenName()%>">
		<img src="<%=tweet.getUser().getProfileImageURL()%>" border=0 title="<%=tweet.getUser().getScreenName()%>&#13;twitter" alt="<%=tweet.getUser().getScreenName()%>" onerror="this.src='http://abs.twimg.com/sticky/default_profile_images/default_profile_4_normal.png';"><br>
		@<%=tweet.getUser().getScreenName()%>
		</a>		
		</td>
		<td style="border: 1px solid #ccc; padding:5px;">
		
		<font title="<%=tweet.getCreatedAt()%>" style="CURSOR:hand;">
		<%
		//out.println(tweet.getText());
		out.println(s);
		%>
		</font>
		
		<br><p style="font-size:10px;"><% 
		out.println(tweet.getCreatedAt());
		%></p></td> </tr><%
	}
%>


</table>
</div>

---------------------------------------------------------------------------

<%
	for(int i = 0; i < 5; i++)
		if(photo_position < PhotoList.size()) {
			//tistory_content = tistory_content + "</tbody></table><p style=\"text-align: center; clear: none; float: none;\"><span class=\"imageblock\" style=\"display:inline-block;;height:auto;max-width:100%\"><span dir=\"";
			%><div style="text-align:center;"><img src="<%=PhotoList.get(photo_position).toString()%>" border=0></div><%
			//tistory_content = tistory_content + PhotoList.get(photo_position).toString() + "\" rel=\"lightbox\" target=\"_blank\"><img src=\"";
			//tistory_content = tistory_content + PhotoList.get(photo_position).toString() + "\" style=\"max-width:100%;height:auto\"></span></span></p><table align=\"center\" style=\"color: rgb(0, 0, 0); font-family: 'Malgun Gothic'; border-collapse: collapse;\"><tbody>";

			tistory_content = tistory_content + "</tbody></table><p style=\"text-align: center; clear: none; float: none;\"><span class=\"imageblock\" style=\"display:inline-block;;height:auto;max-width:100%\"><span dir=\"";
			
			tistory_content = tistory_content + PhotoList.get(photo_position).toString() + "\" rel=\"lightbox\" target=\"_blank\"><img src=\"";
			tistory_content = tistory_content + PhotoList.get(photo_position).toString() + "\" style=\"max-width:100%;height:auto\" alt=\"" + fncDeCode((String)session.getAttribute("keyword")) + ", " + title_side + "\" title=\"" + fncDeCode((String)session.getAttribute("keyword")) + ", " + title_side + "\"></span></span></p><table align=\"center\" style=\"color: rgb(0, 0, 0); font-family: 'Malgun Gothic'; border-collapse: collapse;\"><tbody>";
			
			photo_position++;
			
		}
	

	
	tistory_content = tistory_content + "</tbody></table><p><br></p>";
	
	//System.out.println((String)session.getAttribute("tistory_post"));
	
	if(((String)session.getAttribute("tistory_post")) != null) {
		TistoryClient TC = new TistoryClient();
		TistoryBrainDotsArticle tistoryBrainDotsArticle = new TistoryBrainDotsArticle();
	
	    tistoryBrainDotsArticle.setTitle("[" + fncDeCode((String)session.getAttribute("keyword")) + "] " + title_side);
	    tistoryBrainDotsArticle.setContent(tistory_content);
	    tistoryBrainDotsArticle.setTag((String)tags);
	   // tistoryBrainDotsArticle.setStrategy(list[2]);
	    tistoryBrainDotsArticle.setVisibility("3");
	    
	    tistoryBrainDotsArticle.setCategory("607233");
    

	    //log.info("tistoryBrainDotsArticle={};", tistoryBrainDotsArticle);
	
	    TC.write(tistoryBrainDotsArticle);
	}
	
%>


</body>
</html>