package ca.jrvs.apps.grep;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.io.BufferedReader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JavaGrepImp implements JavaGrep {

    private final Logger logger = LoggerFactory.getLogger(JavaGrep.class);

    private String regex;
    private String rootPath;
    private String outFile;

    public static void main(String[] args) {
        if (args.length != 3) {
            throw new IllegalArgumentException("USAGE: JavaGrep regex rootPath outFile");

        }

        JavaGrepImp javaGrepImp = new JavaGrepImp();
        javaGrepImp.setRegex(args[0]);
        javaGrepImp.setRootPath(args[1]);
        javaGrepImp.setOutFile((args[2]));

        try {
            javaGrepImp.process();
        } catch (Exception ex) {
            javaGrepImp.logger.error("Error: Unable to process", ex);
        }
    }

    @Override
    public void process() throws IOException {
        List<String> matchedLines = new ArrayList<>();
        List<File> listOfFiles = listFiles(getRootPath());
        for (File file : listOfFiles){
            List<String> lines = readLines(file);
            for (String line : lines){
                if (containsPattern(line)){
                    matchedLines.add(line);
                }
            }
        }
        writeToFile(matchedLines);
    }

    @Override
    public List<File> listFiles(String rootDir) {

        List<File> listOfFiles = new ArrayList();
        File folder = new File(rootDir);

//        System.out.println("DEBUG: folder = " + folder.getAbsolutePath());
        for (File file : folder.listFiles()) {
            if (file.isDirectory()){
                listOfFiles.addAll(listFiles(file.getAbsolutePath()));
            } else {
                listOfFiles.add(file);
            }
        }
        return listOfFiles;
    }

    @Override
    public List<String> readLines(File inputFile) {
        List<String> lines = new ArrayList<>();
        try {
            BufferedReader reader = new BufferedReader((new InputStreamReader(new FileInputStream(inputFile), StandardCharsets.UTF_8)));
            String line = reader.readLine();
            while (line != null) {
                lines.add(line);
                line = reader.readLine();
            }
            reader.close();
        } catch (IOException e){
            logger.error("Failed to read file: " + inputFile.getAbsolutePath(), e);
        }

        return lines;
    }

    @Override
    public boolean containsPattern(String line) {
        String regexPattern = ".*" + getRegex() + ".*";
        return line.matches(regexPattern);

    }

    @Override
    public void writeToFile(List<String> lines) throws IOException {
        String fileOutput = getOutFile();
        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(fileOutput), StandardCharsets.UTF_8));

        for (String line: lines){
            writer.write(line);
            writer.newLine();
        }

        writer.close();
    }

    @Override
    public String getRootPath() {
        return rootPath;
    }

    @Override
    public void setRootPath(String rootPath) {
        this.rootPath = rootPath;
    }

    @Override
    public String getRegex() {
        return regex;
    }

    @Override
    public void setRegex(String regex) {
        this.regex = regex;
    }

    @Override
    public String getOutFile() {
        return outFile;
    }

    @Override
    public void setOutFile(String outfile) {
        this.outFile = outfile;
    }
}
