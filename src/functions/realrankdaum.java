package functions;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map.Entry;
import java.util.PriorityQueue;
import java.util.Scanner;

import org.apache.catalina.startup.PasswdUserDatabase;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import twitter4j.MediaEntity;
import twitter4j.Query;
import twitter4j.QueryResult;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.conf.ConfigurationBuilder;   

public class realrankdaum { 
    public static void main(String[] args) throws Exception {
    	
    	ConfigurationBuilder cb = new ConfigurationBuilder();
    	cb.setDebugEnabled(true)
    	  .setOAuthConsumerKey("KAy5pa2z8Z17vTmfZLUM2lS9j")
    	  .setOAuthConsumerSecret("FBg4zB6hPHEejI1qBDEWz1SuvJg3tOwps3hrpY8Gms9I0JfpyC")
    	  .setOAuthAccessToken("597129297-mFaVxKhDbBd7TBc2hmS1rqzcAEzHVY8mTZl99xT4")
    	  .setOAuthAccessTokenSecret("Q77wt4PpjqdjEI1qMn0o0uJLh8FDYaZQv0mYj4E0YLFdI");
    	TwitterFactory tf = new TwitterFactory(cb.build());
    	Twitter twitter = tf.getInstance();
    	
    	
    	
        String pageUrl="http://www.daum.net"; 

        Document document = Jsoup.connect(pageUrl).get();
        ArrayList<String> searchlist = new ArrayList<String>();
        if (null != document) {
            // class �� rank_dummy �� ������ �ִ� div �±״� ���Խ�Ű�� �ʴ´�.
            Elements elements = document.select("ol#realTimeSearchWord > li > div.roll_txt > div:not(.rank_dummy)");
             
            for (int i = 0; i < elements.size(); i++) {
                //System.out.println("------------------------------------------");
                System.out.println("�˻��� : " + elements.get(i).select("span.txt_issue > a").text());
                
                //System.out.println("��ŷ : " + (i + 1));
                //System.out.println("��¿��� : " + elements.get(i).select("span.screen_out").text());
                 
                // <em class="img_vert txt_num ico_up"><span class="screen_out">���</span>10</em>
                // �� HTML ���� ��´ܰ踦 ���ϱ� ���ؼ� ��¿��θ� �����մϴ�.
                //elements.get(i).select("span.screen_out").remove();
                 
                //System.out.println("��´ܰ� : " + elements.get(i).select("em.img_vert").html());
                //System.out.println("��ũ URL : " + elements.get(i).select("span.txt_issue > a").attr("href"));
                //System.out.println("------------------------------------------");
                String title = elements.get(i).select("span.txt_issue > a").text();
                for(String s : title.split(" ")) {
                		
                		searchlist.add(s);
                }

                //System.out.println(title);
             } 
         }
        
       
        // �˻��� ���� ��
        
        System.out.println(searchlist);
        
        ArrayList<WordCount> words;
        
        // �˻������� �ϳ��� ��� for��
        for(String searchItem : searchlist)
        try {
        	String str = "";
       	 	Query query = new Query(searchItem);
            query.setCount(200);	
            query.setLang("ko");

            int repeat = 10;

            QueryResult result;

   	         result = twitter.search(query);
   	         
   	         List<Status> tweets = result.getTweets();
   	         
   	         for(int i = 0; i < repeat; i++) {
   	      
   		         if((query = result.nextQuery()) == null) continue;
   		         result = twitter.search(query);

   		         tweets.addAll(result.getTweets());

   	         }

            for (int i = 0; i < tweets.size(); i++) {
   	         String s = new String(tweets.get(i).getText());
   	    		
   	    		if(filter19(s)) {
   	    			tweets.remove(i--);
   	    			continue;
   	    		}

   	    		
   	    		if(tweets.get(i).getURLEntities().length != 0) {
   	    			tweets.remove(i--);
   	    			continue;
        		}
        		
        		System.out.println(s);
            }
            
            for (Status tweet : tweets) {
           	 
            	if(tweet.isRetweet() == true) continue;

           		if(tweet.getURLEntities().length != 0) {

           			continue;
           		}

            	str+=tweet.getText() + "\n";

            }
            
            Filtering filtering = new Filtering();
            
            Scanner scan = new Scanner(str);
            HashMap<String, Integer> count = new HashMap<String, Integer>();
            // �ܾ� ī��Ʈ �ϱ�
            while (scan.hasNext()) {
            	
                String word = removePunctuations(scan.next());
                word = remove_comma(word);
                word = remove_broadcast(word);
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
                if (wc.word.length() > 1) words.add(wc);
            }
            // �ܾ�ī��Ʈ ��

            
            String tags = "";
        	String title_side = "";
        	int tag_count = 0;
            
        	// ī��Ʈ �̿� ���� �� �±� �����
            for (WordCount wc : words) {

        		if (wc.word.contains("http")) continue;
        		if (wc.word.contains(searchItem)) continue;
        		//if(filtering(wc.word)) continue;
        		if(tag_count++ < 30) tags = tags + wc.word + ",";
        		if(tag_count < 10) title_side = title_side + wc.word + ", ";
        		else if(tag_count == 10) title_side = title_side + wc.word;
        		
        		
        	}
            // ī��Ʈ �̿� ���� �� �±� ����� ��
            
            ArrayList<String> PhotoList = new ArrayList<String>();
        	
        	String tistory_content = "";
        	
        	// ���� ����
        	for (Status tweet : tweets) {
        		
        		String s = new String(tweet.getText());
        		
        		
        		
        		if(filter19(s)) continue;
        		
        		if(tweet.getMediaEntities().length != 0)
        		{

        			for(MediaEntity me : tweet.getMediaEntities())
        			if(me.getType().equals("photo")) {
        				//System.out.println("2");
        				if(!PhotoList.contains(me.getMediaURL())) {
        					PhotoList.add(me.getMediaURL());
        					
        				}
        			}
        			

        		}

        	}
        	// ���� ���� ��
        	
        	int item_num = 0; 
    		int photo_position = 0;
    		
    		tistory_content = tistory_content + "<div class=\"tt_article_useless_p_margin\"><table align=\"center\" style=\"color: rgb(0, 0, 0); font-family: 'Malgun Gothic'; border-collapse: collapse; width:100%;\"><tbody>";
        	
    		for (Status tweet : tweets) {
    			if(tweet.isRetweet() == true) continue;

    			String s = new String(tweet.getText());
    			
    			while(s.contains("https://t.co/")) {

        			int i = s.indexOf("https://t.co/");

        			s = s.replace(s.substring(i, i+23), "");

        			
        		}
        		
    			s = remove_comma(s);
    			
    			tistory_content = tistory_content + "<tr><td width=\"60\" align=\"center\" style=\"border: 1px solid rgb(204, 204, 204); font-size: 10px; padding: 1px;\">";
    			tistory_content = tistory_content + "<a href=\"https://twitter.com/" + (String)tweet.getUser().getScreenName() + "\" target=\"_blank\" title=\"" + tweet.getUser().getScreenName() + "\"> ";
    			tistory_content = tistory_content + "<img src=\"" + tweet.getUser().getProfileImageURL() + "\" border=0 title=\"" + tweet.getUser().getName() + "&#13;@" + tweet.getUser().getScreenName() + "\" alt=\"" + tweet.getUser().getScreenName() + "\" onerror=\"this.src='http://abs.twimg.com/sticky/default_profile_images/default_profile_4_normal.png';\"><br>";
  
    			tistory_content = tistory_content + "</a></td><td style=\"border: 1px solid rgb(204, 204, 204); padding: 5px;\">";
    			tistory_content = tistory_content + "<font title=\"" + tweet.getCreatedAt() + "\" style=\"CURSOR:hand;\">" + s + "</font>";
    			tistory_content = tistory_content + "</td> </tr>";

    			item_num++;
    			if(item_num == 14) tistory_content = tistory_content + "</tbody></table><table align=\"center\" style=\"color: rgb(0, 0, 0); font-family: 'Malgun Gothic'; border-collapse: collapse; width:100%;\"><tbody><tr><td style=\"text-align:center; padding:1px;\"><p style=\"text-align:center;\"><style>.twitsideAd { width: 336px; height: 280px; margin-top: 15px; margin-bottom: 15px; }@media(max-width: 768px) { .twitsideAd { width: 300px; height: 250px; margin-top: 15px; margin-bottom: 15px; } }</style><script async=\"\" src=\"//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js\"></script><ins class=\"adsbygoogle twitsideAd\" style=\"display:inline-block\" data-ad-client=\"ca-pub-8716569569929004\" data-ad-slot=\"4334296770\" data-ad-format=\"auto\"></ins><script>(adsbygoogle = window.adsbygoogle || []).push({});</script></p></td></tr></tbody></table><table align=\"center\" style=\"color: rgb(0, 0, 0); font-family: 'Malgun Gothic'; border-collapse: collapse; width:100%\"><tbody>";
    			else if((item_num % 7) == 0){

    				if(photo_position < PhotoList.size()) {
    					
    							tistory_content = tistory_content + "</tbody></table><p style=\"text-align: center; clear: none; float: none;\"><span class=\"imageblock\" style=\"display:inline-block;;height:auto;max-width:100%\"><span dir=\"";
    							
    							tistory_content = tistory_content + PhotoList.get(photo_position).toString() + "\" rel=\"lightbox\" target=\"_blank\"><img src=\"";
    							tistory_content = tistory_content + PhotoList.get(photo_position).toString() + "\" style=\"max-width:100%;height:auto\" alt=\"" + searchItem + ", " + title_side + "\"></span></span></p><table align=\"center\" style=\"color: rgb(0, 0, 0); font-family: 'Malgun Gothic'; border-collapse: collapse; width:100%;\"><tbody>";
    				
    							photo_position++;
    							

    				}   				
    				
    			}
	
        	}

    		for(int i = 0; i < 5; i++) {
				if(photo_position < PhotoList.size()) {

					tistory_content = tistory_content + "</tbody></table><p style=\"text-align: center; clear: none; float: none;\"><span class=\"imageblock\" style=\"display:inline-block;;height:auto;max-width:100%\"><span dir=\"";
					
					tistory_content = tistory_content + PhotoList.get(photo_position).toString() + "\" rel=\"lightbox\" target=\"_blank\"><img src=\"";
					tistory_content = tistory_content + PhotoList.get(photo_position).toString() + "\" style=\"max-width:100%;height:auto\" alt=\"" + searchItem + ", " + title_side + "\"></span></span></p><table align=\"center\" style=\"color: rgb(0, 0, 0); font-family: 'Malgun Gothic'; border-collapse: collapse;\"><tbody>";
					
					photo_position++;
					
				}
			}
    		
    		
    		tistory_content = tistory_content + "</tbody></table><p><br></p>";

			TistoryClient TC = new TistoryClient();
			TistoryBrainDotsArticle tistoryBrainDotsArticle = new TistoryBrainDotsArticle();
		
		    tistoryBrainDotsArticle.setTitle("[" + searchItem + "] " + title_side);
		    tistoryBrainDotsArticle.setContent(tistory_content);
		    tistoryBrainDotsArticle.setTag((String)tags);
		   // tistoryBrainDotsArticle.setStrategy(list[2]);
		    tistoryBrainDotsArticle.setVisibility("0");
		    
		    tistoryBrainDotsArticle.setCategory("607233");
	
		    TC.write(tistoryBrainDotsArticle);
		    
		    //Thread.sleep(10000);

        }
        catch (TwitterException te) {
           te.printStackTrace();
           System.out.println("Failed to search tweets: " + te.getMessage());
           //System.exit(-1);
       }
        
    } 
    public static String remove_comma(String s) {
    	s = s.replaceAll("@", "");
		s = s.replaceAll("#", "");
		s = s.replaceAll("��", "");
		s = s.replaceAll("��", "");
		s = s.replaceAll("��", "");
		s = s.replaceAll("��", "");
		s = s.replaceAll("��", "");
		s = s.replaceAll("��", "");
		//s = s.replaceAll("(", "");
		//s = s.replaceAll(")", "");
		//s = s.replaceAll("[", "");
		//s = s.replaceAll("]", "");
		s = s.replace('(', ' ');
		s = s.replace(')', ' ');
		s = s.replace('[', ' ');
		s = s.replace(']', ' ');
		s = s.replaceAll("RT", "");
    	return s;
    	
    	
    }
    public static String remove_broadcast(String s) {
    	s = s.replaceAll("KBS", "");
		s = s.replaceAll("SBS", "");
		s = s.replaceAll("MBC", "");
		s = s.replaceAll("JTBC", "");
		s = s.replaceAll("tvN", "");
		
    	return s;
    	
    }
    
    public static boolean filter19(String s) {
    	boolean check = false;
    	

    		//String s = new String(tweet.getText());
    		//if(s.contains("1383")) check = true;
    		if(s.contains("�η�")) check = true;
    		else if(s.contains("Ǯ�η�")) check = true;
    		else if(s.contains("����Ǯ�η�")) check = true;
    		else if(s.contains("����")) check = true;
    		else if(s.contains("�ٵ���")) check = true;
    		//if(s.contains("https://t.co/")) check = true;
    		else if(s.contains("��������Ʈ")) check = true;
    		else if(s.contains("�����ι���")) check = true;
    		else if(s.contains("������Ŀ��")) check = true;
    		else if(s.contains("���������")) check = true;
    		else if(s.contains("����Ǯ�̷�")) check = true;
    		else if(s.contains("��������")) check = true;
    		else if(s.contains("�����̷���")) check = true;
    		else if(s.contains("��������")) check = true;
    		else if(s.contains("���������")) check = true;
    		else if(s.contains("�缳����")) check = true;
    		else if(s.contains("����������")) check = true;
    		else if(s.contains("�缳�������Ʈ��õ")) check = true;
    		else if(s.contains("���ӵ��ٸ�����Ʈ")) check = true;
    		else if(s.contains("���ӵ��ٸ�")) check = true;
    		else if(s.contains("��ٸ�����Ʈ")) check = true;
    		else if(s.contains("��ٸ���������õ")) check = true;
    		else if(s.contains("��ī��")) check = true;
    		else if(s.contains("Ǯ���")) check = true;
    		else if(s.contains("�Ҷ��")) check = true;
    		else if(s.contains("ī����")) check = true;
    		else if(s.contains("�ߵ�")) check = true;
    		else if(s.contains("�ٵ���")) check = true;
    		else if(s.contains("����")) check = true;
    		else if(s.contains("��õ��")) check = true;
    		else if(s.contains("����")) check = true;
    		else if(s.contains("��")) check = true;
    		else if(s.contains("bot")) check = true;
    		else if(s.contains("�����߱���")) check = true;
    		else if(s.contains("010")) check = true;
    		else if(s.contains("�����ȸ�")) check = true;
    		else if(s.contains("�Ｚ�ȸ�")) check = true;
    		else if(s.contains("�е��ȸ�")) check = true;
    		else if(s.contains("�����ȸ�")) check = true;
    		else if(s.contains("����ȸ�")) check = true;
    		else if(s.contains("���̵��ȸ�")) check = true;
    		else if(s.contains("���빮�ȸ�")) check = true;
    		else if(s.contains("���ξȸ�")) check = true;
    		else if(s.contains("�ϻ�ȸ�")) check = true;
    		else if(s.contains("���ʾȸ�")) check = true;
    		else if(s.contains("��赿�ȸ�")) check = true;
    		else if(s.contains("���ȸ�")) check = true;
    		else if(s.contains("��Ǿȸ�")) check = true;
    		else if(s.contains("û��ȸ�")) check = true;
    		else if(s.contains("��赿�ȸ�")) check = true;
    		else if(s.contains("���γ��� ��")) check = true;
    		else if(s.contains("���̻���")) check = true;
    		else if(s.contains("����Ӵ�")) check = true;
    		else if(s.contains("�߻�")) check = true;
    		else if(s.contains("�ɱ׷��ռ�")) check = true;
    		else if(s.contains("�������Ǹ���")) check = true;
    		else if(s.contains("�ٽú���")) check = true;
    		else if(s.contains("�ֽ��ּ�")) check = true;
    		else if(s.contains("����ó»")) check = true;
    		
    		else if(s.contains("�߸������Ʈ")) check = true;
    		else if(s.contains("�ö��̰���")) check = true;
    		else if(s.contains("��ũ���渶��")) check = true;
    		else if(s.contains("���ͳݰ渶")) check = true;
    		else if(s.contains("�Ϸ������")) check = true;
    		else if(s.contains("�ķ����°�")) check = true;
    		else if(s.contains("�򵿽ǽð����ھ�")) check = true;
    		else if(s.contains("337����")) check = true;
    		
    		else if(s.contains("ȣ������")) check = true;
    		else if(s.contains("337����")) check = true;
    		
    		else if(s.contains("�Ҿװ���")) check = true;
    		else if(s.contains("��ǰ�Ǹ���")) check = true;
    		else if(s.contains("��ǰ������ȭ")) check = true;
    		else if(s.contains("����ϻ�ǰ������ȭ")) check = true;
    		else if(s.contains("�����̿������ȭ")) check = true;
    		else if(s.contains("�Ҿװ�������")) check = true;
    		else if(s.contains("�������Ҿװ���")) check = true;
    		else if(s.contains("������̵�")) check = true;
    		
    		else if(s.contains("����Į����")) check = true;
    		else if(s.contains("337����")) check = true;
    		
    		else if(s.contains("����ä�귣��")) check = true;
    		else if(s.contains("�渶�м�")) check = true;
    		else if(s.contains("������")) check = true;
    		else if(s.contains("��Ʈ�渶")) check = true;
    		else if(s.contains("�ϳ�ĳ��Ż")) check = true;
    		else if(s.contains("���̺����")) check = true;
    		else if(s.contains("��ũ���渶")) check = true;
    		else if(s.contains("�ֽķζ�")) check = true;
    		
    		else if(s.contains("ȫ�Ḷī������")) check = true;
    		else if(s.contains("�����ѳ�����")) check = true;
    		
    		else if(s.contains("�Ϻ����̹��渶")) check = true;
    		else if(s.contains("�ĺ���")) check = true;
    		else if(s.contains("�缳�渶")) check = true;
    		else if(s.contains("Ȧ������Ʈ")) check = true;
    		else if(s.contains("��Ŀ����Ʈ")) check = true;
    		
    		else if(s.contains("�ǳ��渶")) check = true;
    		else if(s.contains("���ͳ��Ƕ�")) check = true;
    		

    		else if(s.contains("����ũ��������")) check = true;
    		else if(s.contains("������")) check = true;
    		else if(s.contains("�Ҿװ���")) check = true;   
    		//if(s.contains("��������Ʈ")) check = true;
    		
    		//if(s.contains("MAMAredcarpet")) check = true;
    		//if(s.contains("MAMAredcarpert")) check = true;
    			
    	return check;
    }
    

    private static String removePunctuations(String str) {
        return str.replaceAll("\\p{Punct}|\\p{Digit}", "");
    }
}