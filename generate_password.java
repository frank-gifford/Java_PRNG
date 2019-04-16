// Copyright 2019, Frank Gifford
// This program is free to use for any purpose without restrictions.
//
// Recreate Java PRNG password from a given starting seed.
// java generate_password <alphabet> <seed> <length>
//
// i.e.
// kali# java generate_password ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 89560454678953 35
// FI7CTQsBDvsMwbQNyY6qxV2FunWIUpXpcZm

import java.util.Random; 

public class generate_password 
{ 
    public static void main(String args[]) 
    { 
        char[] chars;
        long seed;
        int chars_len, bytes;
        String ans = "";

        if (args.length != 3) {
            System.out.println("Pass in three argumnets for the alphabet, password and length");
            System.out.println("i.e.");
            System.out.println("java generate_password ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 89560454678953 35");
            System.exit(0);
        }

        chars = args[0].toCharArray();
        chars_len = chars.length;
        seed = Long.parseLong(args[1]);
        bytes = Integer.parseInt(args[2]);

        // Create instance of Random class.
        Random rnd = new Random(seed); 

        // Generate the password.
        for (int i = 0; i < bytes; i++) {
            ans += chars[rnd.nextInt(chars_len)];
        }

        System.out.println(ans);
    }
}

