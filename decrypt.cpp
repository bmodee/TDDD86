/*
 * EL2
 */

#include <iostream>
#include <chrono>
#include "Key.h"
#include <map>

using namespace std;

int
main(int argc, char* argv[])
{
  unsigned char buffer[C+1];     // temporary string buffer
  Key candidate = {{0}};         // a password candidate
  Key encrypted;                 // the encrypted password
  Key candenc;                   // the encrypted password candidate
  Key zero = {{0}};              // the all zero key
  Key T[N];                      // the table T
  map<Key, Key> lowerHalfCand;   // the lower half bit-values of candidate
  Key half = {{0}};              // the half threshold for the table T

  if (argc != 2)
    {
      cout << "Usage:" << endl << argv[0] << " password < rand8.txt" << endl;

      return 1;
    }

  half++;   // adds the first bit to half

  for (int i = 0; i <= N/2; i++){ // loops the half
      half = half + half;  // logic shift left N/2 times which is the middle of the table
  }

  encrypted = KEYinit((unsigned char *) argv[1]);

  // read in table T
  for (int i{0}; i < N; ++i)
    {
      scanf("%s", buffer);
      T[i] = KEYinit(buffer);
    }

  auto begin = chrono::high_resolution_clock::now();

  // creates all subsets of the right half of the words in table T
  do
    {
      candenc = KEYsubsetsum(candidate, T);
      lowerHalfCand.insert(make_pair(candenc, candidate)); // inserts the candidate for the right half of the encrypted word into the map
      ++candidate;  // increases the bit value by 1
    } while (candidate != half); // stops when we have iterated over the right half of the words in the table

  do
    {
      candenc = KEYsubsetsum(candidate, T); 
      if(lowerHalfCand.count(encrypted - candenc) > 0){ // checks if the current candenc is a possible match for the password
        cout << candidate + lowerHalfCand[encrypted - candenc]<< endl; // prints the combined left half with the right half which is a solution 
      }
      candidate = candidate + half; // increments the left half of candidate while leaving the right half untouched
    } while (candidate != zero);  // stops when all zeros

  auto end = chrono::high_resolution_clock::now();
  cout << "Decryption took "
       << std::chrono::duration_cast<chrono::seconds>(end - begin).count()
       << " seconds." << endl;

  return 0;
}
