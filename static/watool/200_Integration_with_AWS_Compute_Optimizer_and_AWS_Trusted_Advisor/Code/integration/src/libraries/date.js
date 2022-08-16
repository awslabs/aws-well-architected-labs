const currentdate = new Date(); 

async function date(){
    const datetime = currentdate.getHours() + ":"  
                    + currentdate.getMinutes() + ":" 
                    + currentdate.getSeconds() + " on "
                    + currentdate.getDate() + "/"
                    + (currentdate.getMonth()+1)  + "/" 
                    + currentdate.getFullYear();
    return datetime;
}

module.exports.date = date;