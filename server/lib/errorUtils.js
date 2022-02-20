exports.error = (message, status) =>{
    let e = new Error(message)
    e.status = status;
    return e;
}