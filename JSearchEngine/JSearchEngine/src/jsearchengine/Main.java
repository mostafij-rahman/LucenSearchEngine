
package jsearchengine;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexWriter;

import java.net.URL;
import java.util.ArrayList;


public class Main {
    

    
    public static void main(String[] args) throws Exception{
        
           Indexer indxer = new Indexer();
           indxer.createIndex();
    }
    

}
