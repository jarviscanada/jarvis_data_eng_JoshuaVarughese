package ca.jrvs.apps.grep;
import java.util.function.Consumer;
import java.util.stream.IntStream;

public class Main {
    public static void main(String[] args){
        LambdaStreamExcImp lse = new LambdaStreamExcImp();

        System.out.println("---- toUpperCase ----");
        lse.toUpperCase("hello", "world").forEach(System.out::println);

        System.out.println("---- filter ----");
        lse.filter(lse.createStrStream("cat", "fat", "bit"), "at")
                .forEach(System.out::println);

        System.out.println("---- getOdd ----");
        lse.getOdd(IntStream.rangeClosed(1, 10))
                .forEach(System.out::println);

        System.out.println("---- squareRoot ----");
        lse.squareRootIntStream(IntStream.of(1, 4, 9))
                .forEach(System.out::println);

        Consumer<String> printer = lse.getLambdaPrinter("msg: [", "]");
        System.out.println("---- printMessages ----");
        lse.printMessages(new String[]{"a", "b"}, printer);
    }
}
