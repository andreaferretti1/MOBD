function update_status_text(h, epoch, max_epochs, iteration)
% Questa funzione aggiorna il testo dello stato di avanzamento
% dell'addestramento
%
% Input:
% - h: handle della dashboard
% - epoch: epoca attuale
% - max_epochs: numero totale epoche
% - iteration: contatore delle iterazioni

progress_text = sprintf(['\n\\bfSTATO AVANZAMENTO:\\rm\n' ...
    'Epoca:      %d / %d\n' ...
    'Iterazione: %d'], ...
    epoch, ...
    max_epochs, ...
    iteration);

% Concateno i testi da mostrare a schermo
set(h.text_handle, 'String', [h.static_info_str, progress_text]);

drawnow limitrate; 

end

