/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package jsearchengine;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.CorruptIndexException;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.store.LockObtainFailedException;
import org.htmlparser.NodeFilter;
import org.htmlparser.Parser;
import org.htmlparser.beans.StringBean;
import org.htmlparser.filters.TagNameFilter;
import org.htmlparser.util.ParserException;

/**
 *
 * @author USER
 */
public class Indexer {
   
    void createIndex() throws CorruptIndexException, LockObtainFailedException, IOException {
		final String FILES_TO_INDEX_DIRECTORY = "G:\\8th Semester\\Information Retrieval\\JSearchEngine\\JSP\\web\\filesToIndex";
		final String INDEX_DIRECTORY = "G:\\8th Semester\\Information Retrieval\\JSearchEngine\\JSearchEngine\\indexDirectory";

		final String FIELD_PATH = "path";
		final String FIELD_CONTENTS = "contents";

		Analyzer analyzer = new StandardAnalyzer();
		boolean recreateIndexIfExists = true;
		IndexWriter indexWriter;
                indexWriter = new IndexWriter(INDEX_DIRECTORY, analyzer, recreateIndexIfExists);
		File dir = new File(FILES_TO_INDEX_DIRECTORY);
		File[] files = dir.listFiles();
		for (File file : files) {
			Document document = new Document();
                         String title = new String();
                         String summary = new String();

			String path = file.getCanonicalPath();

			document.add(new Field(FIELD_PATH, path, Field.Store.YES, Field.Index.NOT_ANALYZED));

                        
                        StringBean sb = new StringBean ();
    sb.setLinks (false);
    sb.setURL (path);
    
    StringReader sr = new StringReader(sb.getStrings ());
        
    document.add(new Field("contents", sr));

    Parser bParser;
    NodeFilter bFilter;
  try
            {
                bParser = new Parser ();
                bFilter = new TagNameFilter ("TITLE");
                bParser.setResource (path);
                title = bParser.parse( bFilter).asString();
       
            }
            catch (ParserException e)
            {
                e.printStackTrace ();
            }
    
            try
            {
      
                bParser = new Parser ();
                bFilter = new TagNameFilter ("BODY");
                bParser.setResource (path);
                try
                {
                summary = bParser.parse( bFilter).asString().substring(0, 200);
                }
                catch(StringIndexOutOfBoundsException e)
                {
                   summary = "";
                }
                
            }
            catch (ParserException e)
            {
                e.printStackTrace ();
            }

    // Add the title as a field that it can be searched and that is stored.
    document.add(new Field("title", title, Field.Store.YES, Field.Index.ANALYZED));
    document.add(new Field("summary",summary, Field.Store.YES, Field.Index.NO));



			//Reader reader = new FileReader(file);
			//document.add(new Field(FIELD_CONTENTS, reader));

			indexWriter.addDocument(document);
		}
		indexWriter.optimize();
		indexWriter.close();}
 
}
