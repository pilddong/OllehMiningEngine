<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
 
<%@ page import="twitter4j.*" %>
<%@ page import="twitter4j.conf.*" %>
<%@ page import="twitter4j.auth.*" %>

<%@ page import="functions.*" %>
<%@ include file="twitter.jsp" %>



<%
/*
TwitterAPIs sns = new TwitterAPIs();
 
//String keyword = request.getParameter("keyword");
// �몄쐞�����앹꽦��諛쏆� �좏겙
sns.setConsumer_key("P2ODm5hwh3iCE3pPU1TtFQ");
sns.setConsumer_secret("IRrvPNwvrW8LbLubZqiyT8E3Tq9o6R9HoGRyf5g");
 
HashMap<String,String> mapCookie = (HashMap) setCookies(request.getCookies());
 
// �몄쬆諛쏆� �좏겙
String access_token = mapCookie.get("_MEI_TWITTER_ACCESS_TOKEN");
String access_tokensecret = mapCookie.get("_MEI_TWITTER_ACCESS_TOKENSECRET");
 
*/


ConfigurationBuilder cb = new ConfigurationBuilder();
cb.setDebugEnabled(true)
  .setOAuthConsumerKey("KAy5pa2z8Z17vTmfZLUM2lS9j")
  .setOAuthConsumerSecret("FBg4zB6hPHEejI1qBDEWz1SuvJg3tOwps3hrpY8Gms9I0JfpyC")
  .setOAuthAccessToken("597129297-mFaVxKhDbBd7TBc2hmS1rqzcAEzHVY8mTZl99xT4")
  .setOAuthAccessTokenSecret("Q77wt4PpjqdjEI1qMn0o0uJLh8FDYaZQv0mYj4E0YLFdI");
TwitterFactory tf = new TwitterFactory(cb.build());
Twitter twitter = tf.getInstance();


// �ъ씤利앹뿬遺�

	 
//out.println(sns.twitter.verifyCredentials().getId()); // �ъ슜���꾩븘��
//out.println(sns.twitter.verifyCredentials().getScreenName()); // �ъ슜���대쫫





//session.setAttribute("keyword", keyword);
//response.sendRedirect("search2.jsp");




%>
   
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Twitter 데이터 마이닝 엔진 - searching...</title>
</head>
<body>
<%=request.getParameter("keyword") %> searching...
<%	
	//request.setCharacterEncoding("EUC-KR");
	
	//int i = 0; 
	ArrayList<WordCount> words = new ArrayList<WordCount>();
	String str = "";
	//String keyword = (String)session.getAttribute("keyword");
	String keyword = (String)request.getParameter("keyword");
	String keyword2 = (String)request.getParameter("keyword2");
	
	String lang = (String)request.getParameter("lang");		
	
	session.setAttribute("keyword", keyword);
	
	//System.out.println(keyword + " " + lang + " ");
	if(keyword2 != null) keyword += keyword2;
	keyword = fncDeCode(keyword);
	//keyword = new String(keyword.getBytes("8859_1"), "EUC-KR");
	System.out.println("트마엔 : " + keyword);
	
	
	if(session.getAttribute("keywordList")==null) {
		session.setAttribute("keywordList", "");
	}
	session.setAttribute("keywordList", ((String)session.getAttribute("keywordList")) + " " + keyword);


	
    try {
    	 
    	 Query query = new Query(keyword);
         query.setCount(200);	
         query.setLang(lang);
         
         String rp = (String)request.getParameter("repeat");
         System.out.println(rp + "회");
         int repeat;
   		 if(rp.equals("")) repeat = 3;
   		 else repeat = Integer.parseInt(rp);
	         
        // query.
         QueryResult result;
        
         //List<Status> tweets = new ArrayList<Status>();
                
         //int r = 0;
         //do {
         
	         result = twitter.search(query);
	         //List<Status> tweetsb = result.getTweets();
	         
	         List<Status> tweets = result.getTweets();
	         
	         for(int i = 0; i < repeat; i++) {
	      
	         //while(true){
		         if((query = result.nextQuery()) == null) continue;
		         result = twitter.search(query);
		         //if(result == null) continue;
		         tweets.addAll(result.getTweets());
		         //if(tweets.size()>50) break;
	         }
	         
	         
	         //tweets.addAll(tweetsb);
	         
	         //System.out.println("getLimit" + result.getRateLimitStatus().getLimit());
	         //System.out.println("getRemaining" + result.getRateLimitStatus().getRemaining());
	         //System.out.println("getResetTimeInSeconds" + result.getRateLimitStatus().getResetTimeInSeconds());
	         //System.out.println("getSecondsUntilReset" + result.getRateLimitStatus().getSecondsUntilReset());
	         
	        
	         //List<Status> tweets = twitter.getTimeline();
	         //r++;
	        // if(r < 2) break;
	         
	         
	         
         
         //} while ((query = result.nextQuery()) != null);
         for (int i = 0; i < tweets.size(); i++) {
	         String s = new String(tweets.get(i).getText());
	    		
	    		if(filter19(s)) tweets.remove(i--);
         }
         
         for (Status tweet : tweets) {
        	 
        	if(tweet.isRetweet() == true) continue;
        	
        	if((String)request.getParameter("urlentity") == null)
        		if(tweet.getURLEntities().length != 0) {
        			//System.out.print("2");
        			continue;
        		}
         	//i++;
         	str+=tweet.getText() + "\n";
             //System.out.println(i + " @" + tweet.getUser().getScreenName() + " - " + tweet.getText());
         	//System.out.println(tweet.getText());
         }
         
         Filtering filtering = new Filtering();
         
         Scanner scan = new Scanner(str);
         HashMap<String, Integer> count = new HashMap<String, Integer>();
         while (scan.hasNext()) {
             String word = removePunctuations(scan.next());
             if (Filtering.filteringList().contains(word)) continue;
             if (word.equals("")) continue;
             Integer n = count.get(word);
             count.put(word, (n == null) ? 1 : n + 1);
         }
         PriorityQueue<WordCount> pq = new PriorityQueue<WordCount>();
         for (Entry<String, Integer> entry : count.entrySet()) {
             pq.add(new WordCount(entry.getKey(), entry.getValue()));
         }
         words = new ArrayList<WordCount>();
         while (!pq.isEmpty()) {
             WordCount wc = pq.poll();
             if (wc.word.length() > 2) words.add(wc);
         }
         session.setAttribute("tistory_post", (String)request.getParameter("tistory_post"));
         session.setAttribute("urlentity", (String)request.getParameter("urlentity"));
         session.setAttribute("result", words);
         session.setAttribute("tweets", tweets);
            
    } catch (TwitterException te) {
        te.printStackTrace();
        System.out.println("Failed to search tweets: " + te.getMessage());
        //System.exit(-1);
    }

	
	// session.setAttribute("result", words);
	
	

	
%>
<jsp:forward page="result.jsp"/>
<a href=<%=response.encodeURL("result.jsp") %> >寃곌낵蹂닿린</a>
</body>
</html>

<%
	
	







%>
 
<%!
// 荑좏궎 �몄텧 硫붿꽌��
private HashMap setCookies(Cookie[] cookies) {
	HashMap mapRet = new HashMap();
 
	if(cookies != null){
		for (int i = 0; i < cookies.length; i++) {
			Cookie obj = cookies[i];
			mapRet.put(obj.getName(),obj.getValue());
		}
	}
 
	return mapRet;
}

private String removePunctuations(String str) {
    return str.replaceAll("\\p{Punct}|\\p{Digit}", "");
}
 
%>

<%!
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



public static boolean filter19(String s) {
	boolean check = false;
	

		//String s = new String(tweet.getText());
		//if(s.contains("1383")) check = true;
		if(s.contains("싸롱")) check = true;
		else if(s.contains("풀싸롱")) check = true;
		else if(s.contains("강남풀싸롱")) check = true;
		else if(s.contains("오피")) check = true;
		else if(s.contains("바둑이")) check = true;
		//if(s.contains("https://t.co/")) check = true;
		else if(s.contains("강남스마트")) check = true;
		else if(s.contains("강남두바이")) check = true;
		else if(s.contains("역삼포커스")) check = true;
		else if(s.contains("강남더블업")) check = true;
		else if(s.contains("강남풀미러")) check = true;
		else if(s.contains("역삼힐링")) check = true;
		else if(s.contains("강남미러룸")) check = true;
		else if(s.contains("강남힐링")) check = true;
		else if(s.contains("도우미주점")) check = true;
		else if(s.contains("사설토토")) check = true;
		else if(s.contains("스포츠토토")) check = true;
		else if(s.contains("사설토토사이트추천")) check = true;
		else if(s.contains("네임드사다리사이트")) check = true;
		else if(s.contains("네임드사다리")) check = true;
		else if(s.contains("사다리사이트")) check = true;
		else if(s.contains("사다리놀이터추천")) check = true;
		else if(s.contains("바카라")) check = true;
		else if(s.contains("풀사롱")) check = true;
		else if(s.contains("소라넷")) check = true;
		else if(s.contains("카지노")) check = true;
		else if(s.contains("야동")) check = true;
		else if(s.contains("바둑이")) check = true;
		else if(s.contains("토토")) check = true;
		else if(s.contains("추천인")) check = true;
		else if(s.contains("룸살롱")) check = true;
		else if(s.contains("봇")) check = true;
		else if(s.contains("bot")) check = true;
		else if(s.contains("강남야구장")) check = true;
		else if(s.contains("010")) check = true;
		else if(s.contains("선릉안마")) check = true;
		else if(s.contains("삼성안마")) check = true;
		else if(s.contains("학동안마")) check = true;
		else if(s.contains("논현안마")) check = true;
		else if(s.contains("역삼안마")) check = true;
		else if(s.contains("방이동안마")) check = true;
		else if(s.contains("동대문안마")) check = true;
		else if(s.contains("종로안마")) check = true;
		else if(s.contains("일산안마")) check = true;
		else if(s.contains("서초안마")) check = true;
		else if(s.contains("방배동안마")) check = true;
		else if(s.contains("방배안마")) check = true;
		else if(s.contains("잠실안마")) check = true;
		else if(s.contains("청담안마")) check = true;
		else if(s.contains("방배동안마")) check = true;
		else if(s.contains("시인나게 놀")) check = true;
		else if(s.contains("모이새오")) check = true;
		
		//if(s.contains("강남스마트")) check = true;
		//if(s.contains("강남스마트")) check = true;
		
		//if(s.contains("MAMAredcarpet")) check = true;
		//if(s.contains("MAMAredcarpert")) check = true;
			
	return check;
}
%>