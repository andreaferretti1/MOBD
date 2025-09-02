function analyze_time_trends(timetable)
% Questa funzione analizza trend temporali per determinare se i clienti
% accettano le offerte in determinati periodi dell'anno
% La funione riceve in input una tabella di due colonne, contenente la
% feature "month" e la label, non codificata

% Codifico la label
timetable.y = encode_label(timetable.y);

% Analizzo i trend su tutti gli anni
trend_table = groupsummary(timetable, 'month', 'mean', 'y');

% Mostro i risultati graficamente
figure;
bar(trend_table.month, trend_table.mean_y);
xlabel('Month');
ylabel('Mean subscriptions');
title('Mean subscriptions over all years');

% Aggiungo la colonna year alla tabella
rows = height(timetable);
years = zeros(rows, 1);
current_year = 2008;

years(1) = current_year;

for row = 2:rows
    if (strcmp(timetable.month(row - 1), 'dec') && strcmp(timetable.month(row), 'jan'))
        current_year = current_year + 1;
    end

    years(row) = current_year;

end

timetable.year = years;

% Calcolo la media delle accettazioni anno per anno
mean_trend = groupsummary(timetable, {'year', 'month'}, 'mean', 'y');

% Calcolo il numero di persone che accettano 
num_trend = groupsummary(timetable, {'year', 'month'});

% Mostro i risultati graficamente
years = unique(mean_trend.year);

for year_idx = 1:length(years)
    
    % Estraggo le tabelle relative a ciascun anno
    mean_year_table = mean_trend(mean_trend.year == years(year_idx), :);
    num_year_table = num_trend(num_trend.year == years(year_idx), :);

    % Disegno il grafico della media
    figure;
    subplot(2,2,1);
    bar(mean_year_table.month, mean_year_table.mean_y);
    xlabel('Month');
    ylabel("Mean subscriptions");
    title("Mean subscriptions for year " + years(year_idx));

    % Disegno il grafico del numero di campioni
    subplot(2,2,2);
    bar(num_year_table.month, num_year_table.GroupCount);
    xlabel('Month');
    ylabel('Number of data');
    title("Number of data for year " + years(year_idx));
end

end

