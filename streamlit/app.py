import streamlit as st
import pandas as pd

st.set_page_config(
    page_title="Movie Analytics Platform",
    page_icon="🎬",
    layout="wide"
)

# --------------------------------------------------
# Snowflake Connection
# --------------------------------------------------

conn = st.connection("snowflake")

# --------------------------------------------------
# Sidebar Navigation
# --------------------------------------------------

st.sidebar.title("🎬 Movie Analytics")
page = st.sidebar.radio(
    "Navigate",
    [
        "📊 Overview",
        "🎬 Movie Detail",
        "🏢 Studio Portfolio",
        "🔎 Explorer"
    ]
)

# ==================================================
# OVERVIEW
# ==================================================

if page == "📊 Overview":

    st.title("🎬 Movie Analytics Platform")
    st.caption("Box Office & OTT Performance Dashboard")

    kpi_df = conn.query("""
        SELECT
            COALESCE(SUM(GROSS_LAKHS), 0) AS TOTAL_GROSS_LAKHS,
            COALESCE(SUM(TICKETS_SOLD), 0) AS TOTAL_TICKETS_SOLD,
            COALESCE(AVG(AVG_TICKET_PRICE), 0) AS AVG_TICKET_PRICE,
            COALESCE(AVG(OCCUPANCY_RATE), 0) AS AVG_OCCUPANCY_RATE,
            COALESCE(SUM(SCREENS), 0) AS TOTAL_SCREENS
        FROM MOVIE_ANALYTICS.SEM.V_BOXOFFICE_ANALYTICS
    """)

    col1, col2, col3, col4, col5 = st.columns(5)

    col1.metric(
        "Total Gross (Lakhs)",
        f"{kpi_df['TOTAL_GROSS_LAKHS'].iloc[0]:,.2f}"
    )

    col2.metric(
        "Tickets Sold",
        f"{int(kpi_df['TOTAL_TICKETS_SOLD'].iloc[0]):,}"
    )

    col3.metric(
        "Avg Ticket Price",
        f"₹{kpi_df['AVG_TICKET_PRICE'].iloc[0]:,.2f}"
    )

    col4.metric(
        "Avg Occupancy",
        f"{kpi_df['AVG_OCCUPANCY_RATE'].iloc[0] * 100:.1f}%"
    )

    col5.metric(
        "Total Screens",
        f"{int(kpi_df['TOTAL_SCREENS'].iloc[0]):,}"
    )

    st.divider()

    # Daily Gross Trend
    st.subheader("📈 Daily Gross Trend")

    daily_df = conn.query("""
        SELECT
            SHOW_DATE,
            SUM(GROSS_LAKHS) AS TOTAL_GROSS_LAKHS
        FROM MOVIE_ANALYTICS.SEM.V_BOXOFFICE_ANALYTICS
        GROUP BY SHOW_DATE
        ORDER BY SHOW_DATE
    """)

    st.line_chart(
        daily_df.set_index("SHOW_DATE")["TOTAL_GROSS_LAKHS"]
    )

    st.subheader("🎬 Top 10 Movies by Gross")

    top_movies_df = conn.query("""
        SELECT
            TITLE,
            TOTAL_GROSS_LAKHS,
            TOTAL_TICKETS_SOLD,
            AVG_OCCUPANCY_RATE
        FROM MOVIE_ANALYTICS.SEM.V_MOVIE_PERFORMANCE
        ORDER BY TOTAL_GROSS_LAKHS DESC
        LIMIT 10
    """)

    st.dataframe(
        top_movies_df,
        use_container_width=True,
        hide_index=True
    )


# ==================================================
# MOVIE DETAIL
# ==================================================

elif page == "🎬 Movie Detail":

    st.title("🎬 Movie Detail")

    movies_df = conn.query("""
        SELECT
            MOVIE_ID,
            TITLE
        FROM MOVIE_ANALYTICS.SEM.V_MOVIE_PERFORMANCE
        ORDER BY TITLE
    """)

    selected_movie = st.selectbox(
        "Select Movie",
        movies_df["TITLE"].tolist()
    )

    movie_id = movies_df.loc[
        movies_df["TITLE"] == selected_movie,
        "MOVIE_ID"
    ].iloc[0]

    movie_df = conn.query(f"""
        SELECT
            *
        FROM MOVIE_ANALYTICS.SEM.V_MOVIE_PERFORMANCE
        WHERE MOVIE_ID = '{movie_id}'
    """)

    row = movie_df.iloc[0]

    st.subheader(selected_movie)

    col1, col2, col3, col4 = st.columns(4)

    col1.metric(
        "Total Gross",
        f"{row['TOTAL_GROSS_LAKHS']:,.2f} L"
    )

    col2.metric(
        "Tickets Sold",
        f"{int(row['TOTAL_TICKETS_SOLD']):,}"
    )

    col3.metric(
        "Avg Ticket Price",
        f"₹{row['AVG_TICKET_PRICE']:,.2f}"
    )

    col4.metric(
        "Avg Occupancy",
        f"{row['AVG_OCCUPANCY_RATE'] * 100:.1f}%"
    )

    st.divider()

    st.write(f"**Genre:** {row['GENRE']}")
    st.write(f"**Language:** {row['LANGUAGE']}")
    st.write(f"**Studio:** {row['STUDIO_NAME']}")
    st.write(f"**Release Type:** {row['RELEASE_TYPE']}")

    st.subheader("📈 Daily Gross")

    movie_daily_df = conn.query(f"""
        SELECT
            SHOW_DATE,
            SUM(GROSS_LAKHS) AS GROSS_LAKHS
        FROM MOVIE_ANALYTICS.SEM.V_BOXOFFICE_ANALYTICS
        WHERE MOVIE_ID = '{movie_id}'
        GROUP BY SHOW_DATE
        ORDER BY SHOW_DATE
    """)

    if not movie_daily_df.empty:
        st.line_chart(
            movie_daily_df.set_index("SHOW_DATE")["GROSS_LAKHS"]
        )


# ==================================================
# STUDIO PORTFOLIO
# ==================================================

elif page == "🏢 Studio Portfolio":

    st.title("🏢 Studio Portfolio")

    studio_df = conn.query("""
        SELECT
            STUDIO_ID,
            STUDIO_NAME
        FROM MOVIE_ANALYTICS.SEM.V_STUDIO_PERFORMANCE
        ORDER BY STUDIO_NAME
    """)

    selected_studio = st.selectbox(
        "Select Studio",
        studio_df["STUDIO_NAME"].tolist()
    )

    studio_id = studio_df.loc[
        studio_df["STUDIO_NAME"] == selected_studio,
        "STUDIO_ID"
    ].iloc[0]

    performance_df = conn.query(f"""
        SELECT *
        FROM MOVIE_ANALYTICS.SEM.V_STUDIO_PERFORMANCE
        WHERE STUDIO_ID = '{studio_id}'
    """)

    row = performance_df.iloc[0]

    col1, col2, col3, col4 = st.columns(4)

    col1.metric(
        "Total Gross",
        f"{row['TOTAL_GROSS_LAKHS']:,.2f} L"
    )

    col2.metric(
        "Movies",
        int(row["MOVIE_COUNT"])
    )

    col3.metric(
        "Tickets Sold",
        f"{int(row['TOTAL_TICKETS_SOLD']):,}"
    )

    col4.metric(
        "Avg Occupancy",
        f"{row['AVG_OCCUPANCY_RATE'] * 100:.1f}%"
    )

    st.divider()

    st.subheader("🎬 Studio Movies")

    studio_movies_df = conn.query(f"""
        SELECT
            TITLE,
            GENRE,
            LANGUAGE,
            TOTAL_GROSS_LAKHS,
            TOTAL_TICKETS_SOLD,
            AVG_OCCUPANCY_RATE
        FROM MOVIE_ANALYTICS.SEM.V_MOVIE_PERFORMANCE
        WHERE STUDIO_NAME = '{selected_studio}'
        ORDER BY TOTAL_GROSS_LAKHS DESC
    """)

    st.dataframe(
        studio_movies_df,
        use_container_width=True,
        hide_index=True
    )


# ==================================================
# EXPLORER
# ==================================================

elif page == "🔎 Explorer":

    st.title("🔎 Box Office Explorer")

    filters_df = conn.query("""
        SELECT DISTINCT
            GENRE,
            REGION,
            CHANNEL,
            COUNTRY
        FROM MOVIE_ANALYTICS.SEM.V_BOXOFFICE_ANALYTICS
    """)

    col1, col2, col3, col4 = st.columns(4)

    genre_options = ["All"] + sorted(
        filters_df["GENRE"].dropna().unique().tolist()
    )

    region_options = ["All"] + sorted(
        filters_df["REGION"].dropna().unique().tolist()
    )

    channel_options = ["All"] + sorted(
        filters_df["CHANNEL"].dropna().unique().tolist()
    )

    country_options = ["All"] + sorted(
        filters_df["COUNTRY"].dropna().unique().tolist()
    )

    selected_genre = col1.selectbox("Genre", genre_options)
    selected_region = col2.selectbox("Region", region_options)
    selected_channel = col3.selectbox("Channel", channel_options)
    selected_country = col4.selectbox("Country", country_options)

    query = """
        SELECT
            SHOW_DATE,
            TITLE,
            GENRE,
            STUDIO_NAME,
            CITY,
            STATE,
            COUNTRY,
            REGION,
            CHANNEL,
            PLATFORM_NAME,
            SCREENS,
            TICKETS_SOLD,
            AVG_TICKET_PRICE,
            GROSS_LAKHS,
            OCCUPANCY_RATE
        FROM MOVIE_ANALYTICS.SEM.V_BOXOFFICE_ANALYTICS
        WHERE 1 = 1
    """

    if selected_genre != "All":
        query += f" AND GENRE = '{selected_genre}'"

    if selected_region != "All":
        query += f" AND REGION = '{selected_region}'"

    if selected_channel != "All":
        query += f" AND CHANNEL = '{selected_channel}'"

    if selected_country != "All":
        query += f" AND COUNTRY = '{selected_country}'"

    query += """
        ORDER BY SHOW_DATE DESC
    """

    explorer_df = conn.query(query)

    st.subheader(f"Results: {len(explorer_df)} records")

    st.dataframe(
        explorer_df,
        use_container_width=True,
        hide_index=True
    )