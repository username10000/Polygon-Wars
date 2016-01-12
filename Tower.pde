public class Tower extends GameObject
{
  int type;
  float speed;
  float damage;
  color colour;
  PShape towerShape;
  PVector cellPosition;
  
  Tower(int type, int x, int y)
  {
    this.type = type;
    setAttributes();
    cellPosition = new PVector(x, y);
    colour = color(random(0, 255), random(0, 255), random(0, 255));
    drawShape();
  }
  Tower()
  {
    this(0, 0, 0);
  }
  
  private void setAttributes()
  {
    // First type of tower
    if (type == 0)
    {
      speed = 0.05;
      damage = 10;
    }
    // Second type of tower
    if (type == 1)
    {
      speed = 0;
      damage = 1;
    }
  }
  private void drawShape()
  {
    float halfSize = cellSize / 2 - (cellSize / 10);
    
    towerShape = createShape();
    towerShape.beginShape();
    towerShape.stroke(colour);
    towerShape.fill(colour);
    towerShape.vertex(0, - halfSize);
    towerShape.vertex(- halfSize, halfSize);
    towerShape.vertex(halfSize, halfSize);
    towerShape.endShape(CLOSE);
  }
  public void render()
  {
    // Render the tower
    if (cellPosition.y >= startCell && cellPosition.y <= endCell)
    {
      // Calculate the coordinates of the enemy
      position.x = border.get("left") + cellSize / 2 + cellPosition.x * cellSize;
      position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell) * cellSize + offset;
      
      // Draw the tower
      pushMatrix();
      translate(position.x, position.y);
      shape(towerShape);
      popMatrix();
    }
  }
  public void update()
  {

  }
}