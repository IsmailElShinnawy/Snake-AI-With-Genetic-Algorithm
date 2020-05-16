class Food{
  
  PVector pos;
  
  Food(){
    pos = new PVector((int)random(cols)*size, (int)random(rows)*size);
  }
  
  Food(float x, float y){
    pos = new PVector(x, y);
  }
  
  void show(){
    stroke(0);
    fill(255, 0, 0);
    rect(pos.x, pos.y, size, size);
  }
  
  Food clone(){
    return new Food(pos.x, pos.y);
  }
  
}
