export var Pixel = (function() {
  let entity = {
    isPainting: false,
    colorPicker: null,
    table: null,
    cells: null
  };

  function clean(raw) {
    if (typeof raw == "undefined") {
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

    const color = entity.colorPicker.value;
    cell.style.backgroundColor = color;
    cell.dataset.color = color;
  }

  entity.encode = function() {
    let encodedTable = [];
    let numRows = 0;
    let numColumns = 0;
    for (let i = 0, row; row = entity.table.rows[i]; i++) {
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
    }
  }

  entity.run = function() {
    entity.table = document.querySelector(".pixel-table");
    entity.cells = document.getElementsByClassName("pixel-column")
    entity.colorPicker = document.querySelector(".color-selector");
    for ( let c of entity.cells ) {
      c.onmousedown = function() { entity.paint(c, true); }
      c.onmouseup = function() { entity.isPainting = false; }
      c.onclick = function() { entity.paint(c, false); };
      c.onmouseover = function() { entity.paintIf(c) };
    }
  }

  return entity;
})();
