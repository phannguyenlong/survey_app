fetch("http://localhost:8080/webserver/database").then(res => {
    if (res.status !== 200) console.log("Error when fetching server");
    else {
        res.json().then(data => console.log(data))
    }
}).catch (err => console.log(err))