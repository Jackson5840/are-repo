/* Formatting function for row details - modify as you need */
var table; 

var baseurl = 'http://cng-nmo-dev5.orc.gmu.edu/are/'

function format ( d ) {
    // `d` is the original data object for the row
    return '<table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">'+
        '<tr>'+
            '<td colspan=2>Original</td>'+
            '<td colspan=2>Duplicate</td>'+
        '</tr>'+
        '<tr>'+
            '<td colspan=2><img src="' + d.dupimg +'"></td>'+
            '<td colspan=2><img src="' + d.orgimg +'"></td>'+
        '</tr>'+
        '<tr>'+
            '<td>Name:</td>'+
            '<td><a target="_blank" href="' + d.duplink + '">'+d.dupname+'</a></td>'+
            '<td>Name:</td>'+
            '<td><a target="_blank" href="' + d.orglink + '">'+d.orgname+'</a></td>'+
        '</tr>'+
        '<tr>'+
            '<td>Archive:</td>'+
            '<td>'+d.duparchive+'</td>'+
            '<td>Archive:</td>'+
            '<td>'+d.orgarchive+'</td>'+
        '</tr>'+
        '<tr>'+
            '<td>Version</td>'+
            '<td>'+d.dupver +'</td>'+
            '<td>Version</td>'+
            '<td>'+d.orgver +'</td>'+
        '</tr>'+
    '</table>';
}

// Edit record
$('#example').on('click', 'a.editor_ignore', function (e) {
    e.preventDefault();

    if (confirm("Are you sure you wish to keep this potential duplicate?")) {
        var rdata = table.row( $(this).parents('tr') ).data();
        fetch(baseurl +'/handleduplicate/' + rdata['orgname'] + '/ignore',{ method: 'get', mode: 'cors' })
            .then(
                function(response) {
                if (response.status !== 200) {
                    console.log('Looks like there was a problem. Status Code: ' +
                    response.status);
                    return;
                }

                // Examine the text in the response
                response.json().then(function(adata) {
                    console.log(adata);
                });
                }
            )
            .catch(function(err) {
                console.log('Fetch Error :-S', err);
            });
        table
            .row( $(this).parents('tr') )
            .remove()
            .draw();
    }
} );

// Delete a record
$('#example').on('click', 'a.editor_remove', function (e) {
    e.preventDefault();
    if (confirm("Are you sure you wish to delete this neuron from main and review DB?")) {
        var rdata = table.row( $(this).parents('tr') ).data();
        fetch(baseurl +'/handleduplicate/' + rdata['orgname'] + '/delete',{ method: 'get', mode: 'cors' })
            .then(
                function(response) {
                if (response.status !== 200) {
                    console.log('Looks like there was a problem. Status Code: ' +
                    response.status);
                    return;
                }

                // Examine the text in the response
                response.json().then(function(adata) {
                    console.log(adata);
                });
                }
            )
            .catch(function(err) {
                console.log('Fetch Error :-S', err);
            });
        table
            .row( $(this).parents('tr') )
            .remove()
            .draw();
    }
    
} );
 
$(document).ready(function() {
    table = $('#example').DataTable( {
        "ajax": "../assets/ajax/duplicates2023b.json",
        "columns": [
            {
                "class":          'details-control',
                "orderable":      false,
                "data":           null,
                "defaultContent": ''
            },
            { "data": "dupname"},
            { "data": "orgname"},
            { "data": "orgarchive"},
            { "data": "orgver"},
            { "data": "srcfilesame"},
            { "data": "level"},
            {
                data: null,
                className: "center",
                defaultContent: '<a href="" class="editor_ignore">Keep</a> / <a href="" class="editor_remove">Delete</a>'
            }
            //{ "data": "d_level"}
//            { "data": "d_imageurl" },
//            { "data": "d_neuronurl" },
//            { "data": "o_name" },
//           { "data": "o_archive" },
//            { "data": "o_version" },
//            { "data": "d_neuronurl" }
        ],
        "order": [[1, 'asc']]
    } );
     
    // Add event listener for opening and closing details
    $('#example tbody').on('click', 'td.details-control', function () {
        var tr = $(this).parents('tr');
        var row = table.row( tr );
 
        if ( row.child.isShown() ) {
            // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');
        }
        else {
            // Open this row
            row.child( format(row.data()) ).show();
            tr.addClass('shown');
        }
    } );

    $('#example tbody').on( 'click', 'img.icon-delete', function () {
        table
            .row( $(this).parents('tr') )
            .remove()
            .draw();
    } );
} );
