import pandas as pd

from matplotlib import pyplot as plt

import numpy as np

from statsmodels.stats.weightstats import DescrStatsW

import matplotlib.gridspec as gridspec

import geopandas as gpd
plt.style.use('seaborn')


mieter = pd.read_stata(
    "/Users/kgoebler/Desktop/Miete und Energie Projekt/Temp/hauptmieter.dta")

mieter["nweight"] = mieter.hhrf1 / np.mean(mieter.hhrf1)

modmieter = mieter[["syear", "nweight", "mblq",
                    "real_rent_sqmtr", "real_bruttowarm_sqmtr"]].dropna()


it = list(range(1995, 2014)) + list(range(2015, 2019))
mblq_sem = []
mblq_mean = []
real_rent_mean = []
real_rent_sem = []
real_warmrent_mean = []
real_warmrent_sem = []

for year in range(len(it)):
    mblq_mean.append(DescrStatsW(modmieter[modmieter.syear == it[year]].mblq,
                                 weights=modmieter[modmieter.syear == it[year]].nweight, ddof=0).mean)
    mblq_sem.append(DescrStatsW(modmieter[modmieter.syear == it[year]].mblq,
                                weights=modmieter[modmieter.syear == it[year]].nweight, ddof=0).std_mean)
    real_rent_mean.append(DescrStatsW(modmieter[modmieter.syear == it[year]].real_rent_sqmtr,
                                      weights=modmieter[modmieter.syear == it[year]].nweight, ddof=0).mean)
    real_rent_sem.append(DescrStatsW(modmieter[modmieter.syear == it[year]].real_rent_sqmtr,
                                     weights=modmieter[modmieter.syear == it[year]].nweight, ddof=0).std_mean)
    real_warmrent_mean.append(DescrStatsW(modmieter[modmieter.syear == it[year]].real_bruttowarm_sqmtr,
                                          weights=modmieter[modmieter.syear == it[year]].nweight, ddof=0).mean)
    real_warmrent_sem.append(DescrStatsW(modmieter[modmieter.syear == it[year]].real_bruttowarm_sqmtr,
                                         weights=modmieter[modmieter.syear == it[year]].nweight, ddof=0).std_mean)


dict = {"Year": it, "mblq_mean": mblq_mean, "mblq_se": mblq_sem,
        "rent_mean": real_rent_mean, "rent_se": real_rent_sem, "warm_mean": real_warmrent_mean, "warm_se":  real_warmrent_sem}

df = pd.DataFrame(dict)

df["mblq_ll"] = df.mblq_mean - 1.96*df.mblq_se
df["mblq_ul"] = df.mblq_mean + 1.96*df.mblq_se

df["rent_ll"] = df.rent_mean - 1.96*df.rent_se
df["rent_ul"] = df.rent_mean + 1.96*df.rent_se

df["warm_ll"] = df.warm_mean - 1.96*df.warm_se
df["warm_ul"] = df.warm_mean + 1.96*df.warm_se

plt.plot(df.Year, df.mblq_mean)
plt.fill_between(df.Year, df.mblq_ll, df.mblq_ul, alpha=0.2)
plt.title("Mietbelastungsquote für Hauptmieterhaushalte in Deutschland")
plt.xlabel("Jahr")
plt.ylabel("Mietbelastungsquote in %")
plt.savefig('mblq.pdf')
plt.show()


plt.plot(df.Year, df.rent_mean, label="Bruttokaltmiete")
plt.fill_between(df.Year, df.rent_ll, df.rent_ul, alpha=0.2)
plt.plot(df.Year, df.warm_mean, label="Bruttowarmmiete")
plt.fill_between(df.Year, df.warm_ll, df.warm_ul, alpha=0.2)
plt.title(
    "Bruttokalt- und Bruttowarmmiete/Quadratmeter (in 2015€) für Hauptmieterhaushalte in Deutschland", wrap=True)
plt.xlabel("Jahr")
plt.ylabel("Quadratmeterpreis in €")
plt.legend()
plt.savefig('real_rent.pdf')
plt.show()

electr_mieter = mieter[["syear", "nweight", "elect_share"]].dropna()

it_elect = list(range(2010, 2014)) + list(range(2015, 2019))
elect_mean = []
elect_sem = []

for year in range(len(it_elect)):
    elect_mean.append(DescrStatsW(electr_mieter[electr_mieter.syear == it_elect[year]].elect_share,
                                  weights=electr_mieter[electr_mieter.syear == it_elect[year]].nweight, ddof=0).mean)
    elect_sem.append(DescrStatsW(electr_mieter[electr_mieter.syear == it_elect[year]].elect_share,
                                 weights=electr_mieter[electr_mieter.syear == it_elect[year]].nweight, ddof=0).std_mean)


dict_elect = {"Year": it_elect,
              "elect_mean": elect_mean, "elect_se": elect_sem}

df_elect = pd.DataFrame(dict_elect)

df_elect["elect_ll"] = df_elect.elect_mean - 1.96*df_elect.elect_se
df_elect["elect_ul"] = df_elect.elect_mean + 1.96*df_elect.elect_se

plt.plot(df_elect.Year, df_elect.elect_mean)
plt.fill_between(df_elect.Year, df_elect.elect_ll,
                 df_elect.elect_ul, alpha=0.2)
plt.title("Anteil Stromkosten am HH-Nettoeinkommen für Hauptmieterhaushalte in Deutschland", wrap=True)
plt.xlabel("Jahr")
plt.ylabel("Anteil in %")
plt.savefig('elect.pdf')
plt.show()


# retriving means by hgnuts1 regions / BULAS

bula_mieter = mieter[["syear", "nweight", "mblq", "hgnuts1"]].dropna()
bula = bula_mieter.hgnuts1.unique()
bula = bula.remove_categories(["[-1] keine Angabe"])

bula_95 = []
bula_00 = []
bula_05 = []
bula_10 = []
bula_15 = []
bula_18 = []

bulas = [bula_95, bula_00, bula_05, bula_10, bula_15, bula_18]
year = [1995, 2000, 2005, 2010, 2015, 2018]

for data in range(len(bulas)):
    for region in range(len(bula)):
        bulas[data].append(DescrStatsW(bula_mieter[(bula_mieter.syear == year[data]) & (bula_mieter.hgnuts1 == bula[region])].mblq,
                                       weights=bula_mieter[(bula_mieter.syear == year[data]) & (bula_mieter.hgnuts1 == bula[region])].nweight, ddof=0).mean)


dict_bula = {"BuLa": bula, "bula_95": bula_95, "bula_00": bula_00, "bula_05": bula_05,
             "bula_10": bula_10, "bula_15": bula_15, "bula_18": bula_18}

bula_df = pd.DataFrame(dict_bula)
bula_df = bula_df.drop(bula_df.index[15])


# Postal code data for Heat Maps

plz_shape_df = gpd.read_file('plz-gebiete.shp', dtype={'plz': str})

plz_shape_df.head()
plt.rcParams['figure.figsize'] = [16, 11]

# Get lat and lng of Germany's main cities.
top_cities = {
    'Berlin': (13.404954, 52.520008),
    'Köln': (6.953101, 50.935173),
    'Düsseldorf': (6.782048, 51.227144),
    'Frankfurt am Main': (8.682127, 50.110924),
    'Hamburg': (9.993682, 53.551086),
    'Leipzig': (12.387772, 51.343479),
    'München': (11.576124, 48.137154),
    'Dortmund': (7.468554, 51.513400),
    'Stuttgart': (9.181332, 48.777128),
    'Nürnberg': (11.077438, 49.449820),
    'Hannover': (9.73322, 52.37052)
}

# Get lat and lng for Bundesländer center points:
mblq_bula_95 = []
mblq_bula_00 = []
mblq_bula_05 = []
mblq_bula_10 = []
mblq_bula_15 = []
mblq_bula_18 = []

bulas = [mblq_bula_95, mblq_bula_00, mblq_bula_05,
         mblq_bula_10, mblq_bula_15, mblq_bula_18]


for i in range(1, 7):
    bulas[i-1] = {
        bula_df.iloc[0, i].round(2): (13.404954, 52.520008),  # Berlin
        # Brandenburg (Cottbus)
        bula_df.iloc[1, i].round(2): (14.32888, 51.75769),
        bula_df.iloc[2, i].round(2): (11.57549, 48.13743),  # Bayern (München)
        bula_df.iloc[3, i].round(2): (8.68417, 50.11552),  # Hessen (Frankfurt)
        bula_df.iloc[4, i].round(2): (8.80777, 53.07516),  # Bremen
        bula_df.iloc[5, i].round(2): (7.466, 51.51494),  # NRW (Dortmund)
        # Niedersachsen (Celle)
        bula_df.iloc[6, i].round(2): (10.08047, 52.62264),
        # Schleswig-Holstein (Neumünster)
        bula_df.iloc[7, i].round(2): (9.98195, 54.07477),
        bula_df.iloc[8, i].round(2): (9.993682, 53.551086),  # Hamburg
        bula_df.iloc[9, i].round(2): (13.73832, 51.05089),  # Sachsen (Dresden)
        bula_df.iloc[10, i].round(2): (9.17702, 48.78232),  # BaWü (Stuttgart)
        bula_df.iloc[11, i].round(2): (7.16379, 50.14511),  # RlP (Cochem)
        # MeckPomm (Güstrow)
        bula_df.iloc[12, i].round(2): (12.17337, 53.7972),
        # Saarland (Saarbrücken)
        bula_df.iloc[13, i].round(2): (6.98165, 49.2354),
        # Thüringen (Erfurt)
        bula_df.iloc[14, i].round(2): (11.03283, 50.9787),
        # Sachsen-Anhalt (Erfurt)
        bula_df.iloc[15, i].round(2): (11.62916, 52.12773)
    }


# Create feature.
plz_shape_df = plz_shape_df \
    .assign(first_dig_plz=lambda x: x['plz'].str.slice(start=0, stop=1))

# region
plz_region_df = pd.read_csv(
    'zuordnung_plz_ort.csv',
    sep=',',
    dtype={'plz': str}
)

plz_region_df.drop('osm_id', axis=1, inplace=True)

plz_region_df.head()

germany_df = pd.merge(
    left=plz_shape_df,
    right=plz_region_df,
    on='plz',
    how='inner'
)

germany_df.drop(['note'], axis=1, inplace=True)
# germany_df.head()


def germanyplot(i):
    fig, ax = plt.subplots()
    germany_df.plot(
        ax=ax,
        column='bundesland',
        categorical=True,
        legend=True,
        legend_kwds={'title': 'Bundesland', 'bbox_to_anchor': (1.35, 0.8)},
        cmap='tab20',
        alpha=0.9
    )
    # for i in range(0, 2):
    for c in bulas[i].keys():
        ax.text(
            x=bulas[i][c][0],
            y=bulas[i][c][1] + 0.08,
            s=c,
            fontsize=12,
            ha='center',
        )

        ax.plot(
            bulas[i][c][0],
            bulas[i][c][1],
            marker='o',
            c='black',
            alpha=0.5
        )
        ax.set(
            title='Deutschland - Mietbelastungsquote in den Bundesländern ' +
            str(year[i]),
            aspect=1.3,
            facecolor='white'
        )
    #plt.savefig('mblq_bula_' + str(year[i]) + '.pdf')


germanyplot(5)
plt.show()


fig, ((ax1, ax2, ax3), (ax4, ax5, ax6)) = plt.subplots(
    nrows=2, ncols=3, sharex=True, sharey=True)
fig.subplots_adjust(hspace=0.0, wspace=0.0)

axes = [ax1, ax2, ax3, ax4, ax5, ax6]

for i in range(0, 6):
    germany_df.plot(ax=axes[i],
                    column='bundesland',
                    categorical=True,
                    legend=False,
                    #legend_kwds={'title': 'Bundesland', 'bbox_to_anchor': (1.35, 0.8)},
                    cmap='tab20',
                    alpha=0.9)
    for c in bulas[i].keys():
        axes[i].axis('off')

        axes[i].text(
            x=bulas[i][c][0],
            y=bulas[i][c][1] + 0.08,
            s=c,
            fontsize=12,
            ha='center',
        )

        axes[i].plot(
            bulas[i][c][0],
            bulas[i][c][1],
            marker='o',
            c='black',
            alpha=0.5
        )
        axes[i].set(
            title='Mietbelastungsquote in ' +
            str(year[i]),
            aspect=1.3,
            facecolor='white'
        )


plt.savefig('mblq_bula.png')
plt.show()

#germany_df.head()
germany_df.plot(column='bundesland')
#plt.show()

bula_df.loc[bula_df['BuLa'] == '[10] Nordrhein-Westfalen', 'bundesland'] = 'Nordrhein-Westfalen'
bula_df.loc[bula_df['BuLa'] == '[11] Rheinland-Pfalz', 'bundesland'] = 'Rheinland-Pfalz'
bula_df.loc[bula_df['BuLa'] == '[12] Saarland', 'bundesland'] = 'Saarland'
bula_df.loc[bula_df['BuLa'] == '[9] Niedersachsen', 'bundesland'] = 'Niedersachsen'
bula_df.loc[bula_df['BuLa'] == '[1] Baden-Wuerttemberg', 'bundesland'] = 'Baden-Württemberg'
bula_df.loc[bula_df['BuLa'] == '[7] Hessen', 'bundesland'] = 'Hessen'
bula_df.loc[bula_df['BuLa'] == '[15] Schgeneswig-Holstein', 'bundesland'] = 'Schleswig-Holstein'
bula_df.loc[bula_df['BuLa'] == '[6] Hamburg', 'bundesland'] = 'Hamburg'
bula_df.loc[bula_df['BuLa'] == '[5] Bremen', 'bundesland'] = 'Bremen'
bula_df.loc[bula_df['BuLa'] == '[2] Bayern', 'bundesland'] = 'Bayern'
bula_df.loc[bula_df['BuLa'] == '[16] Thueringen', 'bundesland'] = 'Thüringen'
bula_df.loc[bula_df['BuLa'] == '[14] Sachsen-Anhalt', 'bundesland'] = 'Sachsen-Anhalt'
bula_df.loc[bula_df['BuLa'] == '[8] Mecklenburg-Vorpommern', 'bundesland'] = 'Mecklenburg-Vorpommern'
bula_df.loc[bula_df['BuLa'] == '[4] Brandenburg', 'bundesland'] = 'Brandenburg'
bula_df.loc[bula_df['BuLa'] == '[13] Sachsen', 'bundesland'] = 'Sachsen'
bula_df.loc[bula_df['BuLa'] == '[3] Berlin', 'bundesland'] = 'Berlin'

bula_df = bula_df[["bundesland", "bula_95", "bula_00",
                   "bula_05", "bula_10", "bula_15", "bula_18"]]
bula_df.head()

germany_df_new = pd.merge(
    left=germany_df,
    right=bula_df,
    on='bundesland',
    how='inner'
)

#germany_df_new.head()

vmin, vmax = 17, 33

fig, axes = plt.subplots(nrows=2, ncols=3, sharex=True, sharey=True, figsize=(8.5, 5))

bulaxes = ["bula_95", "bula_00", "bula_05",
           "bula_10", "bula_15", "bula_18"]

for i, ax in enumerate(axes.flat):
    germany_df_new.plot(
        column= bulaxes[i], cmap="autumn_r", categorical=True, ax=ax, linewidth=0.01, edgecolor="0.9")

    ax.axis("off")
    ax.set(
        title=str(year[i]),
        aspect=1.3,
        facecolor='white'
    )

sm = plt.cm.ScalarMappable(
    cmap='autumn_r', norm=plt.Normalize(vmin=vmin, vmax=vmax))
# empty array for the data range
sm._A = []
# add the colorbar to the figure

cbar = fig.colorbar(sm, ax=axes.ravel().tolist(), shrink=0.95)
cbar.set_label('Mietbelastungsquote', wrap = True)

fig.savefig("germany_heat.png", dpi=300)

plt.show()

