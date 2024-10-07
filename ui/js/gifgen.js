var serverbase = 'https://neuromorpho.org/ingestapi/';


$(document).ready(function() {
    getarchives()
    ;
});

function getarchives(){
    $.get(serverbase + "getarchives/", function(data, status){
        console.log(data)
        genbuttonlist(data)
    });
}

function gifgen(archive) {
    setTimeout(checkstatus, 3000,archive);
    $.get(serverbase + "gifgen/" + archive, function(data, status){
        if (status == "success") {
            updateprogress(archive,100);
            

        }
        
    });    
}

function checkstatus(archive) {
    /* Checks status of ingestion for archive.   
    */
    
    $.get(serverbase + "checkgif/" + archive, function(data, status){
        console.log(status)
        if (status == "success") {
            updateprogress(archive,data.progress);
            if (data.status == "error"  ) {
                alert("Error genarating gifs for archive: " + archive)
            }
            else {
                if (data.progress == 100) {
                    //alert(archive + ": gifs generated.")
                }
                else {
                    setTimeout(checkstatus, 3000,archive);
                }
            }
        }
    });    
}


function updateprogress(archive,percent) {
    pbar = document.getElementById("pbar_" + archive);
    //thewidth = parseFloat(pbar.style.width.slice(0,-1)) + 10;
    pbar.style.width = (percent).toString() + '%'; 
}

function genbuttonlist(data) {
    elem = `<table width="100%">`;
    data.data.forEach(element => {
        elem += `<tr>
            <td width=150><button type="button" class="btn btn-primary" onclick="gifgen('${element.name}')">${element.name}</button></td>
            <td><div class="progress">
            <div id='pbar_${element.name}' class="progress-bar bg-success" style="width: 0%" role="progressbar" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100"></div>
            </div>
            </td>
        </tr>`
        checkstatus(element.name);
    });
    elem += "</table>";
    $(elem).appendTo(".test1");
    
}