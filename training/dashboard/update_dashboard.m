function update_dashboard(h, iter, epoch, max_epochs, train_loss, train_f2_score, eval_loss, eval_f2_score, eval_frequency, is_validation)
% Questa funzione aggiorna i grafici e il conteggio epoche e iterazioni.
%
% Input:
% - h è l'handle per poter accedere alle componenti della dashboard
% - iter è l'iterazione corrente
% - epoch è l'epoca corrente
% - max_epochs è il numero massimo di epoche
% - train_loss è la loss media sul training set
% - train_f2_score è l'F2-score sul training set
% - eval_loss è la loss media sul validation/test set
% - eval_f2_score è l'F2-score sul validation/test set
% - eval_frequency è la frequenza con cui si calcolano le metriche su validation/test set
% - is_validation indica se sto effettuando tuning degli iperparametri



% Aggiorno le metriche sul training set
set(h.line_train_loss, 'XData', 1:iter, 'YData', train_loss(1:iter));
if ~is_validation
    set(h.line_train_f2, 'XData', 1:iter, 'YData', train_f2_score(1:iter));
    set(h.line_eval_f2,'XData', 1 : eval_frequency : iter, 'YData', eval_f2_score(1 : floor(iter / eval_frequency)));
end

% Aggiorno metriche sul validation/test set
if(mod(iter, eval_frequency) == 0)

    index = iter / eval_frequency;

    set(h.line_eval_loss, 'XData', eval_frequency : eval_frequency : iter, 'YData', eval_loss(1 : index));

    if ~is_validation
        set(h.line_eval_f2,'XData', eval_frequency : eval_frequency : iter, 'YData', eval_f2_score(1 : index));
    end

end


% Aggiorno il testo
progress_text = sprintf(['\n\\bfSTATO AVANZAMENTO:\\rm\n' ...
    'Epoca:      %d / %d\n' ...
    'Iterazione: %d'], ...
    epoch, ...
    max_epochs, ...
    iter);

new_string = [h.static_info_str, progress_text];

set(h.text_handle, 'String', new_string);

drawnow limitrate;
end