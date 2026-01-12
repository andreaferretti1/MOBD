function update_dashboard(h, iter, epoch, max_epochs, train_loss, train_f2_score, eval_loss, eval_f2_score, is_validation)
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
% - is_validation indica se sto effettuando tuning degli iperparametri



% Aggiorno le metriche sul training set
set(h.line_train_loss, 'XData', 1:epoch, 'YData', train_loss(1:epoch));
if ~is_validation
    set(h.line_train_f2, 'XData', 1:epoch, 'YData', train_f2_score(1:epoch));
end



set(h.line_eval_loss, 'XData', 1:epoch, 'YData', eval_loss(1 : epoch));

if ~is_validation

    set(h.line_eval_f2,'XData', 1:epoch, 'YData', eval_f2_score(1 : epoch));

end


update_status_text(h, epoch, max_epochs, iter)
end