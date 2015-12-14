package functions;

import com.google.common.collect.Lists;
//import jdk.nashorn.internal.ir.annotations.Ignore;

import lombok.extern.slf4j.Slf4j;
import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;

@Slf4j
public class TistoryClientTest {

    TistoryClient tistory;

    @Before
    public void setUp() throws Exception {
        tistory = new TistoryClient();
    }

    @Test
    public void testWrite() throws Exception {

        ArrayList<String[]> arrayList = Lists.newArrayList();
        arrayList.add(new String[]{"189", "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/2yNC56F4VoA\" frameborder=\"0\" allowfullscreen></iframe>",
                "순발력을 요하는 스테이지이다.\n한쪽은 단순히 받쳐 줄 정도만 만들고 한쪽은 반대쪽으로 넘겨줄 모양으로 만들어 주면 된다."});
        arrayList.add(new String[]{"190", "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/_kvWWVc2USE\" frameborder=\"0\" allowfullscreen></iframe>",
                "간단하다. 파란공이 작은 구멍으로 들어 갈 수 있도록 미끄럼틀을 만들어 주면 된다."});
        arrayList.add(new String[]{"191", "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/xnXJUGdad9w\" frameborder=\"0\" allowfullscreen></iframe>",
                "파란공이 오른쪽으로 떨어질 수 있을 정도의 각도로만 잠깐 만들어 주면 된다. 그 다음은 언덕의 기울기로 저절로 왼쪽으로 내려 오게 된다."});

        for (String[] list : arrayList) {
            TistoryBrainDotsArticle tistoryBrainDotsArticle = new TistoryBrainDotsArticle();
            tistoryBrainDotsArticle.setTitle(list[0]);
            tistoryBrainDotsArticle.setContent(list[1]);
            //tistoryBrainDotsArticle.setStage(list[0]);
            //tistoryBrainDotsArticle.setYoutube(list[1]);
           // tistoryBrainDotsArticle.setStrategy(list[2]);
            tistoryBrainDotsArticle.setVisibility(String.valueOf(TistoryVisibility.PUBLISH));

            //log.info("tistoryBrainDotsArticle={};", tistoryBrainDotsArticle);

            tistory.write(tistoryBrainDotsArticle);
        }
    }

    //@Ignore
    @Test
    public void testModify() throws Exception {
        TistoryBrainDotsArticle tistoryBrainDotsArticle = new TistoryBrainDotsArticle();

        //tistory.modify(tistoryBrainDotsArticle);
    }

    @Test
    public void testCategoryList() throws Exception {
        tistory.categoryList();
    }
}