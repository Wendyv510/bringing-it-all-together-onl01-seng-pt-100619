class Dog 
  
  attr_accessor :name, :breed, :id  
  
  def initialize(name:,breed:,id:nil)
    @name = name 
    @breed = breed 
    @id = id 
  end
  
  def self.create_table 
    sql = "CREATE TABLE dogs(  
            id INTEGER PRIMARY KEY 
            );"
            
   DB[:conn].execute(sql)
  end 
  
  def self.drop_table 
    sql = "DROP TABLE dogs;"
    
    DB[:conn].execute.(sql)
  end 
  
  def self.new_from_db(row)
    new_dog = self.new 
    new_dog.id = row[0] 
    new_dog.name = row[1]
    new_dog.breed = row[2]
    new_dog 
  end 
  
  def self.find_by_name(name)
    sql = "SELECT *
           FROM dogs
           WHERE  name = ?;" 
           
    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end 
  
  def self.find_by_id(id)
    sql = "SELECT * 
           FROM dogs 
           WHERE id = ?;"
    
    result = DB[:conn].execute(sql,id)[0]
      Dog.new(result[0],result[1],result[2])
    
  end 
  
  def save 
      sql = "INSERT INTO dogs(name,breed)
             VALUES (?,?);"
             
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs;")[0][0]
      
  end 
  
  def update 
    sql = "UPDATE dogs SET name = ?, breed = ?, WHERE id = ?;"
    
    DB[:conn].execute(sql,self.name,self.breed,self.id)
  end 
  
  def self.create(name:,breed:)
    dog = self.new(name,breed)
    dog.save 
    dog 
  end 
  
  def self.find_or_create_by(name:,breed:)
    
    dog = DB[:conn].execute("SELECT * FROM dogs 
           WHERE name = ? AND breed = ?",name,breed)
    
    if !dog.empty? 
      dog_data = dog[0]
      dog = Dog.new(dog_data[0],dog_data[1],dog_data[2])
    else 
      dog = self.create({name: name, breed: breed})
    end 
    dog 
  end 
  
end 