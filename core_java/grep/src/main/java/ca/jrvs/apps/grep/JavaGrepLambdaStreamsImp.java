package ca.jrvs.apps.grep;

import java.io.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JavaGrepLambdaStreamsImp extends JavaGrepImp {
    private final Logger logger = LoggerFactory.getLogger(JavaGrepLambdaStreamsImp.class);

    public static void main(String[] args) {
        if (args.length != 3) {
            throw new IllegalArgumentException("USAGE: JavaGrep regex rootPath outFile");
        }

        JavaGrepLambdaStreamsImp grep = new JavaGrepLambdaStreamsImp();
        grep.setRegex(args[0]);
        grep.setRootPath(args[1]);
        grep.setOutFile((args[2]));

        try {
            grep.process();
        } catch (Exception ex) {
            grep.logger.error("Error: Unable to process", ex);
        }
    }

    @Override
    public void process() throws IOException {
        List<String> matchedLines = listFiles(getRootPath()).stream()
                .flatMap(file -> readLines(file).stream())
                // Stream<String> (all lines from all files)
                .filter(this::containsPattern)
                .collect(Collectors.toList());

        writeToFile(matchedLines);
    }

    @Override
    public List<File> listFiles(String rootDir) {
        try {
            Stream<Path> paths = Files.walk(Paths.get(rootDir));
                return paths
                        .filter(Files::isRegularFile)
                        .map(Path::toFile)
                        .collect(Collectors.toList());
        } catch ( IOException e) {
            logger.error("Failed to list files from rootDir: " + rootDir, e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public  List<String> readLines(File inputFile) {
        try {
            Stream<String> lines = Files.lines(inputFile.toPath(), StandardCharsets.UTF_8);
            return  lines.collect(Collectors.toList());
        } catch (IOException e){
            logger.error("Failed to read file: " + inputFile.getAbsolutePath(), e);
            throw new RuntimeException(e);
        }
    }
}
