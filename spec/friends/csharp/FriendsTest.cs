using System;
using friends;

public class FriendsTest {
  
  public static void Main()
   {
      Console.WriteLine("Friends Test!");
      Vector vector = new Vector(2,3);
      if(vector.X != 2 || vector.Y != 3) {
      	throw new System.InvalidOperationException("Vector initial value should be (2,3)");
      }
      vector.X = 3;
      Vector vector2 =friends.friends.__add__(vector, 5);
      if(vector2.X != 8 || vector2.Y != 8) {
      	throw new System.InvalidOperationException("Vector2 value should be (8,8)");
      }
      Vector vector3 =friends.friends.__mul__(vector2, 3);
      if(vector3.X != 24 || vector3.Y != 24) {
      	throw new System.InvalidOperationException("Vector3 value should be (24,24)");
      }
      Vector vector4 =friends.friends.__neg__(vector2);
      if(vector4.X != -8 || vector4.Y != -8) {
      	throw new System.InvalidOperationException("Vector4 value should be (-8,-8)");
      }
      Vector vector5 =friends.friends.__sub__(vector2, friends.friends._friend_friendFunction());
      if(vector5.X != 3 || vector5.Y != 3) {
      	throw new System.InvalidOperationException("Vector5 value should be (3,3)");
      }
   }
}
