const filterInvalid = function(settings, data, dataIndex) {
  const table = $('.table').DataTable();
  const $row = table.rows(dataIndex).nodes().to$().first();
  const validMeme = !$row.attr('data-valid') || $row.data('valid');
  const validOnlyCheckBox = $('#valid_only');

  return validOnlyCheckBox.is(':checked') ? validMeme : true;
};

$.fn.dataTable.ext.search.push(filterInvalid);


const dataTableConfiguration = {
  "pageLength": 50,
  "dom": "<iftlpi>",
  "columnDefs": [{ "width": "40%", targets: "limited"}],
  "scrollX": "true",
  "scrollY": "55vh",
  "select": "single",
  "autoResize": false
};

const selectRowAction = function (row) {
  const memeURL = row.find("input.link").val();
  $("#meme_view").attr("src", memeURL);
};

$(document).ready(function () {
  $(".table").on("init.dt", function () {
    const table = $(this).dataTable().api();
    if (0 < table.rows().length) {
      const row = table.rows(0);
      row.select();
      selectRowAction(row.nodes().to$());
    }
  });
  
  const table = $('.table').DataTable(dataTableConfiguration);

  $('#valid_only').change(() => table.draw());

  table.on("select", function (e, dt, type, indexes) {
    if (type === "row") {
      selectRowAction(table.rows(indexes).nodes().to$());
    }
  });

});
