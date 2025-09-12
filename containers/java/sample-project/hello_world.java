import java.util.Scanner;

/**
 * Simple Hello World program in Java
 */
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
        System.out.println("Welcome to Java!");
        
        // Get user input
        Scanner scanner = new Scanner(System.in);
        System.out.print("What's your name? ");
        String name = scanner.nextLine();
        System.out.println("Nice to meet you, " + name + "!");
        
        scanner.close();
    }
}
