import java.util.Hashtable;
import java.util.Map;

int cellsPerLine;
int cellsPerCol;
int cellsPerHeight;
int startCell, endCell;
int lastCheck = millis();
float screenSize;
float gap;
float screenWidth, screenHeight;
float cellSize;
int[][] map;
Map<String, Float> border = new HashMap<String, Float>();
PVector mousePosition = new PVector(-1, -1, -1);

void setup()
{
  //size(displayWidth, displayHeight);
  fullScreen();
  background(0);
  stroke(255);
  textAlign(CENTER);
  
  // Import a map from a file
  //importMap();
  
  // Random map
  randomMap();
  
  // Initial Settings
  initialSettings();
  
  // Change the size of the screen
  //surface.setSize(displayWidth / 2, displayHeight / 2);
}

void draw()
{
  background(0);
  
  // Draw the borders of the screen
  noFill();
  stroke(255);
  rect(border.get("left"), border.get("top"), screenWidth, screenHeight);
  
  // Only for debugging
  /*
  for (int i = 0 ; i <= cellsPerLine ; i++)
  {
    // Vertical Lines
    line(border.get("left") + cellSize * i, border.get("top"), border.get("left") + cellSize * i, border.get("top") + screenHeight);
  }
  for (int i = 0 ; i <= cellsPerHeight ; i++)
  {
    // Horizontal Lines
    line(border.get("left"), border.get("top") + cellSize * i, border.get("left") + screenWidth, border.get("top") + cellSize * i);
  }*/
  
  // Draw the occupied cells
  drawRoad();
  
  // Mark the cell if it's hovered
  if (mousePosition.z == 0)
  {
    // Change the colour of the selected cell depending if it's a valid position
    if (map[(int)mousePosition.x + startCell][(int)mousePosition.y] >= 1)
    {
      stroke(255, 0, 0);
      fill(255, 0, 0, 50);
    }
    else
    {
      stroke(0, 255, 0);
      fill(0, 255, 0, 50);
    }
    rect(border.get("left") + mousePosition.y * cellSize, border.get("top") + mousePosition.x * cellSize, cellSize, cellSize);
  }
  // Do stuff if the cell is clicked on
  if (mousePosition.z == 1)
  {
    // Check if the clicked cell is a tower and do things
  }
  
  // Draw all the information needed on the screen
  drawInfo();
  
  // Check if the mouse is hovering something
  mouseHover();
}

void initialSettings()
{
  // Set the borders
  border.put("top", map(3, 0, 100, 0, height));
  border.put("bottom", map(3, 0, 100, 0, height));
  border.put("left", map(0.1, 0, 100, 0, width));
  border.put("right", map(0.1, 0, 100, 0, width));
  
  // Calculate the screen width and height
  screenWidth = width - border.get("left") - border.get("right");
  screenHeight = height - border.get("top") - border.get("bottom");
  
  // Calculate the cell size
  cellSize = screenWidth / cellsPerLine;
  
  // Calculate how many rows of cols can fit on the screen and change the screen height and bottom border to match
  cellsPerHeight = (int)(screenHeight / cellSize);
  screenHeight = cellSize * cellsPerHeight;
  border.put("bottom", height - screenHeight - border.get("top"));
  startCell = 0;
  endCell = cellsPerHeight;
}

boolean checkAround(PVector pos, int roadNo)
{
  // Check the next position to verify if there are any roads around it
  int count = 0;
  
  if (map[(int)pos.y - 1][(int)pos.x] == roadNo)
    count ++;
  if (map[(int)pos.y + 1][(int)pos.x] == roadNo)
    count ++;
  if (map[(int)pos.y][(int)pos.x - 1] == roadNo)
    count ++;
  if (map[(int)pos.y][(int)pos.x + 1] == roadNo)
    count ++;
  
  if (count <= 1)
    return true;
  else
    return false;
}

boolean checkConnection(PVector pos, int roadNo)
{
  // Check if there is another road around that this road has intersected
  int count = 0;
  
  if (map[(int)pos.y - 1][(int)pos.x] != roadNo && map[(int)pos.y - 1][(int)pos.x] != 0)
    count ++;
  if (map[(int)pos.y + 1][(int)pos.x] != roadNo && map[(int)pos.y + 1][(int)pos.x] != 0)
    count ++;
  if (map[(int)pos.y][(int)pos.x - 1] != roadNo && map[(int)pos.y][(int)pos.x - 1] != 0)
    count ++;
  if (map[(int)pos.y][(int)pos.x + 1] != roadNo && map[(int)pos.y][(int)pos.x + 1] != 0)
    count ++;
    
  if (count > 0)
    return true;
  else
    return false;
}

void randomMap()
{
  // Get a random odd value for the number of columns
  cellsPerLine = (int)random(20, 30);
  if (cellsPerLine % 2 == 0)
  {
    cellsPerLine --;
  }
  
  // Get a random odd value for the number of lines
  cellsPerCol = (int)random(cellsPerLine + 1, cellsPerLine + 10);
  if (cellsPerCol % 2 == 0)
  {
    cellsPerCol --;
  }
  
  // Allocate enough space for the 2D array
  map = new int[cellsPerCol][cellsPerLine];
  
  // Add the the destination
  for (int i = 0 ; i < cellsPerLine ; i++)
  {
    map[cellsPerCol - 1][i] = 10;
  }
  
  int numRoads = 8;
  
  for (int i = 1 ; i <= numRoads ; i++)
  {
    PVector curRoad;
    PVector direction;
    switch((int)random(0, 3))
    {
      case 0:
      {
        // Start from top
        curRoad = new PVector((int)random(1, cellsPerLine - 2), 0);
        direction = new PVector(0, 1);
        
        while (map[(int)curRoad.y][(int)curRoad.x - 1] != 0 || map[(int)curRoad.y][(int)curRoad.x + 1] != 0 || map[(int)curRoad.y][(int)curRoad.x] != 0)
        {
          curRoad.x = (int)random(1, cellsPerLine - 2);
        }
        
        break;
      }
      case 1:
      {
        // Start from left
        curRoad = new PVector(0, (int)random(1, cellsPerCol / 2));
        direction = new PVector(1, 0);
        
        while (map[(int)curRoad.y - 1][(int)curRoad.x] != 0 || map[(int)curRoad.y + 1][(int)curRoad.x] != 0 || map[(int)curRoad.y][(int)curRoad.x] != 0)
        {
          curRoad.y = (int)random(1, cellsPerCol / 2);
        }
        
        break;
      }
      default:
      {
        // Start from right
        curRoad = new PVector(cellsPerLine - 1, (int)random(1, cellsPerCol / 2));
        direction = new PVector(-1, 0);
        
        while (map[(int)curRoad.y - 1][(int)curRoad.x] != 0 || map[(int)curRoad.y + 1][(int)curRoad.x] != 0 || map[(int)curRoad.y][(int)curRoad.x] != 0)
        {
          curRoad.y = (int)random(1, cellsPerCol / 2);
        }
                
        break;
      }
    }
    
    // Add the first element
    map[(int)curRoad.y][(int)curRoad.x] = i;
    curRoad.add(direction);
    
    // Make a random road until it reached the destination
    while (curRoad.y != cellsPerCol - 2 && !checkConnection(curRoad, i))
    {
      // Add the current road to the map
      map[(int)curRoad.y][(int)curRoad.x] = i;
      
      // Change the direction
      switch((int)random(0, 3))
      {
        case 0:
        {
          // Left
          float temp = direction.x;
          direction.x = (-1) * direction.y;
          direction.y = (-1) * temp;
          break;
        }
        case 1:
        {
          // Right
          if (direction.x == 0)
          {
            direction.x = (-1) * direction.y;
            direction.y = 0;
          }
          else
          {
            direction.y = direction.x;
            direction.x = 0;
          }
          break;
        }
        default:
        {
          // Straight
          break;
        }
      }
      
      // Go in that direction if possible
      curRoad.add(direction);
      if ((int)curRoad.x == 0 || (int)curRoad.x == cellsPerLine - 1 || (int)curRoad.y == 0 || (int)curRoad.y == cellsPerCol - 1 || direction.y == -1)
      {
          curRoad.sub(direction);
      }
      else 
      {
        if (!checkAround(curRoad, i))
          curRoad.sub(direction);
      }
    }
    
    // Add the final part of the road
    map[(int)curRoad.y][(int)curRoad.x] = i;
  }
}

void importMap()
{
  // Read the file
  String[] lines = loadStrings("map.txt");
  
  // Calculate the cells per line and per column
  cellsPerLine = lines[0].length();
  cellsPerCol = lines.length;
  
  // Allocate enough space for the 2D array
  map = new int[cellsPerCol][cellsPerLine];
  
  // Get the 2D array
  for (int i = 0 ; i < cellsPerCol ; i++)
  {
    for (int j = 0 ; j < cellsPerLine ; j++)
    {
      if (lines[i].charAt(j) == '1')
      {
        map[i][j] = 1;
      }
      else
      {
        map[i][j] = 0;
      }
      //print(map[i][j] + " ");
    }
    //println();
  }
}

void drawRoad()
{
  // Draw the occupied cells
  for (int i = 0 ; i < endCell - startCell ; i++)
  {
    for (int j = 0 ; j < cellsPerLine ; j++)
    {
      if (map[i + startCell][j] >= 1 && map[i + startCell][j] < 10)
      {
        fill(255);
        stroke(255);
        rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize, cellSize, cellSize);
      }
      if (map[i + startCell][j] == 10)
      {
        fill(0, 255, 255);
        stroke(0, 255, 255);
        rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize, cellSize, cellSize);
      }
    }
  }
}

void drawInfo()
{
  // Draw the top and bottom arrows
  fill(255);
  textAlign(CENTER, BOTTOM);
  if (startCell != 0)
    text("/\\", width / 2, border.get("top"));
  textAlign(CENTER, TOP);
  if (endCell != cellsPerCol)
    text("\\/", width / 2, height - border.get("bottom"));
}

void mouseHover()
{ 
  // Move the screen up
  if (mouseY < border.get("top"))
  {
    if (startCell > 0 && millis()> lastCheck + 100)
    {
      startCell --;
      endCell --;
      lastCheck = millis();
    }
  }
  // Move the screen down
  if (mouseY > border.get("top") + screenHeight)
  {
    if (endCell < cellsPerCol && millis()> lastCheck + 100)
    {
      startCell ++;
      endCell ++;
      lastCheck = millis();
    }
  }
  
  // Mark the selected cell
  if (mouseX > border.get("left") && mouseX < width - border.get("right") && mouseY > border.get("top") && mouseY < height - border.get("bottom"))
  {
    mousePosition.x = (int)map(mouseY, border.get("top"), height - border.get("bottom"), 0, cellsPerHeight);
    mousePosition.y = (int)map(mouseX, border.get("left"), width - border.get("right"), 0, cellsPerLine);
    mousePosition.z = 0;
  }
  else
  {
    mousePosition.x = -1;
    mousePosition.y = -1;
    mousePosition.z = -1;
  }
}