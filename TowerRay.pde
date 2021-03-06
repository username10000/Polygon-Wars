public class TowerRay extends Tower implements DamageUp, SpeedUp, RangeUp
{
  TowerRay(int x, int y)
  {
    super(x, y);
    speed = 0.5;
    damage = 5;
    colour = color(0, 255, 0);
    drawShape();
    type = 1;
    //audio = minim.loadFile("/Sounds/T1.wav");
    sample = minim.loadSample("/Sounds/T1.wav", 512);
    createRay();
  }
  TowerRay()
  {
    this(0, 0);
  }
  
  /*
  public void update()
  {
    // Create the ray
    if (!created)
    {
      Ray ray = new Ray(cellPosition.x, cellPosition.y, color(255), speed, damage);
      ray.isAlive = false;
      weapons.add(ray);
      created = true;
    }
  }
  */
  
  private void createRay()
  {
    Ray ray = new Ray(cellPosition.x, cellPosition.y, color(255), speed, damage);
    ray.isAlive = false;
    ray.audio = this.audio;
    ray.sample = this.sample;
    weapons.add(ray);
    created = true;
  }
  
  public void DamageIncrease()
  {
    for (int i = 0 ; i < weapons.size() ; i++)
    {
      if (weapons.get(i) instanceof Ray)
      {
        Ray ray = (Ray)weapons.get(i);
        if (ray.sCell.x == cellPosition.x && ray.sCell.y == cellPosition.y)
        {
          ray.damage += 1;
          break;
        }
      }
    }
    upgradeLevel[0] ++;
  }
    
  public void SpeedIncrease()
  {
    for (int i = 0 ; i < weapons.size() ; i++)
    {
      if (weapons.get(i) instanceof Ray)
      {
        Ray ray = (Ray)weapons.get(i);
        if (ray.sCell.x == cellPosition.x && ray.sCell.y == cellPosition.y)
        {
          ray.speed -= 0.07;
          break;
        }
      }
    }
    upgradeLevel[1] ++;
  }
  
  public void RangeIncrease()
  {
    for (int i = 0 ; i < weapons.size() ; i++)
    {
      if (weapons.get(i) instanceof Ray)
      {
        Ray ray = (Ray)weapons.get(i);
        if (ray.sCell.x == cellPosition.x && ray.sCell.y == cellPosition.y)
        {
          ray.fieldRadius += cellSize;
          break;
        }
      }
    }
    fieldRadius += cellSize;
    upgradeLevel[2] ++;
  }
}