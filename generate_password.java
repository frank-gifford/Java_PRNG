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
	char[] chars = args[0].toCharArray();
	int chars_len = chars.length;
	long seed = Long.parseLong(args[1]);
	int len = Integer.parseInt(args[2]);
	String ans = "";

        // Create instance of Random class.
        Random rnd = new Random(seed); 

	// Generate the password.
        for (int i = 0; i < len; i++) {
            ans += chars[rnd.nextInt(chars_len)];
        }

	System.out.println(ans);
    }
}

