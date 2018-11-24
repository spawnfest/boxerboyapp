export var Pixel = (function() {
  let entity = {
    isPainting: false,
    colorPicker: null,
    table: null,
    cells: null
  };

  function clean(raw) {
    if (typeof raw == "undefined" || ! raw) {
      return null;
    } else {
      return raw;
    }
  }

  entity.paintIf = function(cell) {
    if (entity.isPainting) {
      entity.paint(cell);
    }
  }

  entity.paint = function(cell, isStillPainting) {
    if (isStillPainting) {
      entity.isPainting = true;
    }

    const color = entity.colorPicker.val();
    cell.css('background-color', color);
    cell.attr("data-color", color);
  }

  entity.encode = function() {
    let encodedTable = [];
    let numRows = 0;
    let numColumns = 0;

    for (let i = 0, row; row = entity.table[0].rows[i]; i++) {
       numRows += 1;
       numColumns = 0;
       let encodedRow = []
       for (let j = 0, col; col = row.cells[j]; j++) {
          numColumns += 1;
          encodedRow.push(clean(col.dataset.color));
       }
       encodedTable.push(encodedRow);
    }
    return {
      rows: numRows,
      columns: numColumns,
      pixels: encodedTable,
    };
  }

  entity.run = function() {
    entity.table = $(".pixel-table");
    entity.cells = $(".pixel-column")
    entity.colorPicker = $(".color-selector");

    entity.table.on("mousedown", "td", function() { entity.paint($(this), true) });
    entity.table.on("mouseup", "td", function() { entity.isPainting = false; });
    entity.table.on("click", "td", function() { entity.paint($(this), false); });
    entity.table.on("mouseover", "td", function() { entity.paintIf($(this)); });
  }

  return entity;
})();
