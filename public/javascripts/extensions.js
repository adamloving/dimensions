//extend the Object class to have a keys method for hashes
function getKeys(obj){
  var keys = [];

  for(var key in obj){ 
    if (obj.hasOwnProperty(key))
      keys.push(key);
  }
  return keys;
};
