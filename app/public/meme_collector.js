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

const setupHistogram = function () {
    const tagSelectors = $(document).find(".legend input[type='checkbox']");
    const memes = $(document).find(".histogram .meme");
    
    if (0 >= tagSelectors.length || 0 >= memes.length) {
        return;
    }

    const toggleMemes = function () {
        const tagSelector = this;
        const tag = tagSelector.getAttribute("name");
        const relatedMemes = memes.filter("." + tag);

        if (tagSelector.checked) {
            relatedMemes.show();
        } else {
            relatedMemes.hide();
        }
    };

    tagSelectors.change(toggleMemes);
    
    $("a#select_all").click(() => {
        tagSelectors.prop("checked", true);
        memes.show();
    });
    $("a#select_none").click(() => {
        tagSelectors.prop("checked", false);
        memes.hide();
    });
    $("a#invert_selection").click(() => {
        tagSelectors.prop("checked", (_, oldValue) => !oldValue);
        tagSelectors.trigger("change");
    });
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

  setupHistogram();

});
